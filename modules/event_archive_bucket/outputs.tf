output "bucket_name" {
  value = aws_s3_bucket.event_archive.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.event_archive.arn
}