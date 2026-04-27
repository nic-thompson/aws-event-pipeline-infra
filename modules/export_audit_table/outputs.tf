output "table_name" {
  value = aws_dynamodb_table.export_audit.name
}

output "table_arn" {
  value = aws_dynamodb_table.export_audit.arn
}