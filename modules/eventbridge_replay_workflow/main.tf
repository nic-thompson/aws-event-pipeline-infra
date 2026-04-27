resource "aws_sfn_state_machine" "replay_machine" {
  name     = "signalforge-${var.environment}-archive-replay"
  role_arn = aws_iam_role.replay_role.arn

  definition = file("${path.module}/state_machine.json")

  tags = var.tags
}