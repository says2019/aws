resource "aws_sfn_state_machine" "approval_flow" {
  name     = "approval-flow"
  role_arn = aws_iam_role.lambda_exec_role.arn

  definition = jsonencode({
    StartAt = "NotifyNewRecord",
    States = {
      NotifyNewRecord = {
        Type     = "Task",
        Resource = aws_lambda_function.lambda_functions["notify_new_record"].arn,
        Next     = "WaitForApproval"
      },
      WaitForApproval = {
        Type       = "Task",
        Resource   = "arn:aws:states:::lambda:invoke.waitForTaskToken",
        Parameters = {
          FunctionName = aws_lambda_function.lambda_functions["return_task_token"].arn,
          Payload = {
            "token.$" = "$$.Task.Token",
            "input.$" = "$"
          }
        },
        Next = "PurchaseCapacityBlock"
      },
      PurchaseCapacityBlock = {
        Type     = "Task",
        Resource = aws_lambda_function.lambda_functions["purchase_capacity_block"].arn,
        Next     = "SetRequestStatus"
      },
      SetRequestStatus = {
        Type     = "Task",
        Resource = aws_lambda_function.lambda_functions["set_request_status"].arn,
        Next     = "SubmitApprovalRequest"
      },
      SubmitApprovalRequest = {
        Type     = "Task",
        Resource = aws_lambda_function.lambda_functions["submit_approval_request"].arn,
        End      = true
      }
    }
  })
}
