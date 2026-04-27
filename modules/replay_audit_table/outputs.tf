output "table_name" {
  value = aws_dynamodb_table.replay_audit.name
}

output "table_arn" {
  value = aws_dynamodb_table.replay_audit.arn
}