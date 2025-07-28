variable "pythonfunctionapparn" {
  type = map(string)
}

# Step Function Role
resource "aws_iam_role" "step_function_role" {
  name = "step-function-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "states.amazonaws.com"
        },
        Effect = "Allow",
        Sid = "StepFunctionAssumeRole"
      }
    ]
  })
}

# Step Function IAM Policy
resource "aws_iam_role_policy" "step_function_policy" {
  name = "step-function-policy"
  role = aws_iam_role.step_function_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          var.pythonfunctionapparn["notify_new_record"],
          var.pythonfunctionapparn["return_task_token"],
          var.pythonfunctionapparn["purchase_capacity_block"],
          var.pythonfunctionapparn["send_approval_email"],
          var.pythonfunctionapparn["set_request_status"],
          var.pythonfunctionapparn["submit_approval_request"]
        ]
      }
    ]
  })
}

# Step Function Definition
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "approval-flow"
  role_arn = aws_iam_role.step_function_role.arn

  definition = jsonencode({
    Comment = "Approval Workflow using Lambda and Task Token",
    StartAt = "NotifyNewRecord",
    States = {
      NotifyNewRecord = {
        Type = "Task",
        Resource = "arn:aws:states:::lambda:invoke",
        Parameters = {
          FunctionName = var.pythonfunctionapparn["notify_new_record"],
          Payload = {
            "input.$" = "$"
          }
        },
        Next = "WaitForApproval"
      },
      WaitForApproval = {
        Type = "Task",
        Resource = "arn:aws:states:::lambda:invoke.waitForTaskToken",
        Parameters = {
          FunctionName = var.pythonfunctionapparn["return_task_token"],
          Payload = {
            "token.$" = "$$.Task.Token",
            "input.$" = "$"
          }
        },
        Next = "PurchaseCapacityBlock"
      },
      PurchaseCapacityBlock = {
        Type = "Task",
        Resource = "arn:aws:states:::lambda:invoke",
        Parameters = {
          FunctionName = var.pythonfunctionapparn["purchase_capacity_block"],
          Payload = {
            "input.$" = "$"
          }
        },
        Next = "SendApprovalEmail"
      },
      SendApprovalEmail = {
        Type = "Task",
        Resource = "arn:aws:states:::lambda:invoke",
        Parameters = {
          FunctionName = var.pythonfunctionapparn["set_request_status"],
          Payload = {
            "input.$" = "$"
          }
        },
        Next = "SubmitApprovalRequest"
      },
      SetRequestStatus = {
        Type = "Task",
        Resource = "arn:aws:states:::lambda:invoke",
        Parameters = {
          FunctionName = var.pythonfunctionapparn["set_request_status"],
          Payload = {
            "input.$" = "$"
          }
        },
        Next = "SubmitApprovalRequest"
      },
      SubmitApprovalRequest = {
        Type = "Task",
        Resource = "arn:aws:states:::lambda:invoke",
        Parameters = {
          FunctionName = var.pythonfunctionapparn["submit_approval_request"],
          Payload = {
            "input.$" = "$"
          }
        },
        End = true
      }
    }
  })
}
