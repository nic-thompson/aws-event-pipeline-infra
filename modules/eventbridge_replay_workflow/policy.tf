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
  name = "signalforge-${var.environment}-replay-policy"
  role = aws_iam_role.replay_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "events:StartReplay"
        ]
        Resource = [
          var.archive_arn,
          var.event_bus_arn
        ]
      },

      {
        Effect = "Allow"
        Action = [
          "events:DescribeReplay"
        ]
        # DescribeReplay does not support resource-level constraints
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Resource = var.replay_audit_table_arn
      }

    ]
  })
}