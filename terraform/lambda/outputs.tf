output "lambda_function_names" {
  value = [for k in aws_lambda_function.functions : k.function_name]
}
