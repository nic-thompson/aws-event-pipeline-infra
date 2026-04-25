resource "aws_kms_key" "signalforge" {
  description             = "SignalForge shared encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "signalforge_alias" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.signalforge.key_id
}
