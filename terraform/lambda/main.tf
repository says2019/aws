resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_lambda_function" "lambda_functions" {
  for_each = toset(var.lambda_names)

  function_name = each.key
  filename      = "${path.module}/terraform/lambda/packages/${each.key}.zip"
  handler       = "${replace(each.key, "_", "-")}.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn
  source_code_hash = filebase64sha256("${path.module}/terraform/lambda/packages/${each.key}.zip")
}
