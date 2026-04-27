resource "aws_dynamodb_table" "export_audit" {
  name         = "signalforge-${var.environment}-export-audit"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "export_id"

  attribute {
    name = "export_id"
    type = "S"
  }

  tags = var.tags
}