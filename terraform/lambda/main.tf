variable "lambda_functions" {
  type = map(object({
    source_path = string
    handler     = string
    runtime     = string
    role_arn    = string
  }))
}

resource "aws_lambda_function" "functions" {
  for_each = var.lambda_functions

  function_name = each.key
  filename      = "${path.module}/packages/${each.key}.zip"
  handler       = each.value.handler
  runtime       = each.value.runtime
  role          = each.value.role_arn
  source_code_hash = filebase64sha256("${path.module}/packages/${each.key}.zip")

  environment {
    variables = {
      ENV = "dev"
    }
  }
}
