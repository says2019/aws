output "lambda_arns" {
  value = { for k, f in aws_lambda_function.functions : k => f.arn }
}
