output "dynamodb_table_name" {
  value = aws_dynamodb_table.var.table_name.name
}
