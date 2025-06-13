terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.14"
}

resource "aws_s3_bucket" "bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = {
    Terraform    = "true"
    CostType     = var.cost_type
    CostCategory = var.cost_category
    S3Bucket     = var.bucket_name
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }

  depends_on = [aws_s3_bucket.bucket]
}

locals {
  policy_principals = flatten([var.additional_principals, ["${var.iam_role_arn}"]])
}

data "aws_iam_policy_document" "bucket_policydoc" {
  statement {
    sid    = "AllowBasicAccess"
    effect = "Allow"
    resoruce = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["${jsonencode(local.policy_principals)}"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policydoc.json

  depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  count  = var.versioning ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  count  = var.retention_enabled ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = "Expire all at ${var.retention_days} days"
    status = var.simple_retention_enabled ? "Enabled" : "Disabled"
    abort_incomplete_multipart_upload {
      days_after_initiation = var.incomplete_multipart_days
    }
    expiration {
      days = var.retention_days
    }
    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }

  dynamic "rule" {
    for_each = var.custom_retention[*]
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "filter" {
        for_each = rule.value.filter[*]
        content {
          dynamic "tag" {
            for_each = filter.value.tag[*]
            content {
              key   = tag.value.key
              value = tag.value.value
            }
          }
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration[*]
        content {
          days = expiration.value.days
        }
      }
    }
  }
}
