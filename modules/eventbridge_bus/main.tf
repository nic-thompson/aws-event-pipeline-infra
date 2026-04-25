resource "aws_cloudwatch_event_bus" "telemetry" {
  name = "${var.name_prefix}-telemetry-bus"

  tags = var.tags
}