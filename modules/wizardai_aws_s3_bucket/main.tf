resource "random_string" "suffix" {
  length           = 20
  special          = false
  upper            = false
}

locals {
  prefix      = "wizardai"
}

resource "aws_s3_bucket" "bucket" {
  bucket = format("%s-%s-%s-%s", local.prefix, var.bucket_name, var.environment, random_string.suffix.result)
  // merge var.tags with the default tags
  tags   = merge(var.tags, {
    Name        = var.bucket_name
    Owner       = var.owner
    Environment = var.environment
  })
}

resource "aws_kms_key" "bucket_key" {
  description = "This key is used to encrypt bucket objects"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(var.policyStatements, var.acl != "private" ? [
      {
        Sid       = "DenyUnencryptedTransport"
        Effect    = "Deny"
        Action    = "*"
        Resource  = ["${aws_s3_bucket.bucket.arn}", "${aws_s3_bucket.bucket.arn}/*"]
        Principal = "*"
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ] : [])
  })
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_controls" {
  depends_on = [ aws_s3_bucket_policy.bucket_policy ]
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "sse_config" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}
