output "archive_name" {
  value = aws_cloudwatch_event_archive.telemetry_archive.name
}

output "archive_arn" {
  description = "ARN of the EventBridge archive"
  value       = aws_cloudwatch_event_archive.telemetry_archive.arn
}