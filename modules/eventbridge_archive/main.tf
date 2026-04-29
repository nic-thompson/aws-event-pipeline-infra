resource "aws_cloudwatch_event_archive" "telemetry_archive" {
  name             = "${var.environment}-telemetry-archive"
  event_source_arn = var.event_bus_arn
  retention_days   = var.retention_days
  event_pattern    = var.event_pattern
}
