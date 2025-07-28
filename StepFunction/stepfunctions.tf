variable "pythonfunctionapparn" {
  description = "ARN of the Lambda function to be used in Step Function"
  type        = string
}

# Step Function Role
resource "aws_iam_role" "step_function_role" {
  name = "step-function-role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "StepFunctionAssumeRole"
      }
    ]
  }
  EOF
}

# Step Function IAM Policy
resource "aws_iam_role_policy" "step_function_policy" {
  name = "step-function-policy"
  role = aws_iam_role.step_function_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Resource": "${var.pythonfunctionapparn}"
      }
    ]
  }
  EOF
}

# Step Function Definition
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "work_flow"
  role_arn = aws_iam_role.step_function_role.arn

  definition = <<-EOF
  {
    "Comment": "Invoke AWS Lambda from Step Function with Terraform",
    "StartAt": "ExampleLambdaFunctionApp",
    "States": {
      "ExampleLambdaFunctionApp": {
        "Type": "Task",
        "Resource": "arn:aws:states:::lambda:invoke",
        "Parameters": {
          "FunctionName": "${var.pythonfunctionapparn}",
          "Payload": {
            "input.$": "$"
          }
        },
        "End": true
      }
    }
  }
  EOF
}
