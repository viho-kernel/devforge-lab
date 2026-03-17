resource "aws_s3_bucket" "this" {
  bucket = "${var.project}-${var.environment}-${var.purpose}-backend-bucket"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-${var.purpose}-bucket"

    }
  )
}

#---------------------Block ALL PUBLIC Access---------------------#
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#-----------------------Versionig-------------------------------------#
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

#-----------------------Encryption--------------------------------------#
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }

}

# ─── Bucket Policy ────────────────────────────────────────────────────────────
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  depends_on = [aws_s3_bucket_public_access_block.this]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(

      # Always deny HTTP
      [{
        Sid       = "DenyNonSSL"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }],

      # Read-only users (optional)
      length(var.readonly_user_arns) > 0 ? [{
        Sid    = "AllowReadOnly"
        Effect = "Allow"
        Principal = {
          AWS = var.readonly_user_arns
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetObjectVersion"
        ]
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      }] : [],

      # Admin role (optional)
      var.admin_role_arn != null ? [{
        Sid    = "AllowAdminAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.admin_role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetObjectVersion",
          "s3:DeleteObjectVersion"
        ]
        Resource = [
          aws_s3_bucket.this.arn,
          "${aws_s3_bucket.this.arn}/*"
        ]
      }] : []
    )
  })
}

# ─── Lifecycle (only if versioning is on) ─────────────────────────────────────
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiry_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
