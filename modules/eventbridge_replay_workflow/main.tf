resource "aws_sfn_state_machine" "replay_machine" {
  name     = "signalforge-${var.environment}-archive-replay"
  role_arn = aws_iam_role.replay_role.arn

  definition = templatefile(
    "${path.module}/state_machine.json",
    {
      replay_audit_table_name = var.replay_audit_table_name
    }
  )

  tags = var.tags
}