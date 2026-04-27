resource "aws_iam_role" "replay_role" {
  name = "signalforge-${var.environment}-replay-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "replay_policy" {
  role = aws_iam_role.replay_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "events:StartReplay",
          "events:DescribeReplay",
          "events:CancelReplay"
        ]
        Resource = "*"
      }
    ]
  })
}