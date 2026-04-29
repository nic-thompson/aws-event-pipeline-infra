resource "aws_s3_bucket" "event_archive" {
  bucket = "${var.name_prefix}-event-archive"

  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_public_access_block" "event_archive_public_access" {
  bucket = aws_s3_bucket.event_archive.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "event_archive_versioning" {
  bucket = aws_s3_bucket.event_archive.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "event_archive_encryption" {
  bucket = aws_s3_bucket.event_archive.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "event_archive_lifecycle" {
  bucket = aws_s3_bucket.event_archive.id

  rule {
    id     = "archive-old-telemetry"
    status = "Enabled"

    filter {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
}