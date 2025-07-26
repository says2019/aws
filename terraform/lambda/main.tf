provider "aws" {
  region = "ap-south-1"  # Update as needed
}

variable "lambda_functions" {
  type = map(string)
  default = {
    "notify-new-record"         = "notify-new-record"
    "purchase-capacity-block"   = "purchase-capacity-block"
    "return-task-token"         = "return-task-token"
    "send-approval-email"       = "send-approval-email"
    "set-request-status"        = "set-request-status"
    "submit-approval-request"   = "submit-approval-request"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "functions" {
  for_each = var.lambda_functions

  function_name = each.key
  filename      = "${path.module}/packages/${each.value}.zip"
  source_code_hash = filebase64sha256("${path.module}/packages/${each.value}.zip")

  role    = aws_iam_role.lambda_exec.arn
  handler = "${each.value}.lambda_handler"
  runtime = "python3.12"
  timeout = 10
}
