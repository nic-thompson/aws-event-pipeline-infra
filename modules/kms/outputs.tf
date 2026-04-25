output "kms_key_arn" {
  value = aws_kms_key.signalforge.arn
}

output "kms_key_id" {
  value = aws_kms_key.signalforge.key_id
}
