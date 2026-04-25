resource "aws_sqs_queue" "dlq" {
  name = "${var.name_prefix}-${var.queue_name}-dlq"

  message_retention_seconds = var.dlq_retention_seconds

  kms_master_key_id = var.kms_key_arn
}

resource "aws_sqs_queue" "queue" {
  name = "${var.name_prefix}-${var.queue_name}-queue"

  visibility_timeout_seconds = var.visibility_timeout_seconds

  message_retention_seconds = var.message_retention_seconds

  kms_master_key_id = var.kms_key_arn

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })
}