resource "aws_sfn_state_machine" "dataset_export" {
  name     = "signalforge-${var.environment}-dataset-export"
  role_arn = aws_iam_role.dataset_export_role.arn
  tags     = var.tags

  definition = jsonencode({
    Comment = "SignalForge dataset export stub workflow"

    StartAt = "RecordExportStarted"

    States = {

      RecordExportStarted = {
        Type = "Task"
        Resource = "arn:aws:states:::aws-sdk:dynamodb:putItem"

        Parameters = {
          TableName = var.export_audit_table_name

          Item = {
            export_id = {
              "S.$" = "$.export_id"
            }

            requested_at = {
              "S.$" = "$.requested_at"
            }

            status = {
              S = "STARTED"
            }
          }
        }

        ResultPath = null
        Next       = "WriteExportObject"
      }

      WriteExportObject = {
        Type = "Task"
        Resource = "arn:aws:states:::aws-sdk:s3:putObject"

        Parameters = {
          Bucket = var.export_bucket_name

          "Key.$" = "States.Format('exports/{}.json', $.export_id)"

          Body = jsonencode({
            status = "exported"
          })
        }

        ResultPath = "$.s3_result"
        Next       = "RecordExportCompleted"
      }

      RecordExportCompleted = {
        Type = "Task"
        Resource = "arn:aws:states:::aws-sdk:dynamodb:updateItem"

        Parameters = {
          TableName = var.export_audit_table_name

          Key = {
            export_id = {
              "S.$" = "$.export_id"
            }
          }

          ExpressionAttributeNames = {
            "#s" = "status"
          }

          ExpressionAttributeValues = {
            ":status" = {
              S = "COMPLETED"
            }
          }

          UpdateExpression = "SET #s = :status"
        }

        End = true
      }
    }
  })
}