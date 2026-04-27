resource "aws_dynamodb_table" "replay_audit" {
  name         = "signalforge-${var.environment}-replay-audit"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "replay_name"

  attribute {
    name = "replay_name"
    type = "S"
  }

  tags = var.tags
}
