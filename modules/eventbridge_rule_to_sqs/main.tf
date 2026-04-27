resource "aws_cloudwatch_event_rule" "rule" {
  name           = "${var.name_prefix}-${var.rule_name}"
  event_bus_name = var.event_bus_name

  event_pattern = jsonencode({
    "detail-type" = [var.detail_type]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "sqs_target" {
  rule           = aws_cloudwatch_event_rule.rule.name
  event_bus_name = var.event_bus_name
  target_id      = "${var.rule_name}-target"
  arn            = var.queue_arn
}

resource "aws_sqs_queue_policy" "allow_eventbridge" {
  queue_url = var.queue_url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEventBridgeSendMessage"
        Effect = "Allow"

        Principal = {
          Service = "events.amazonaws.com"
        }

        Action   = "sqs:SendMessage"
        Resource = var.queue_arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.rule.arn
          }
        }
      }
    ]
  })
}