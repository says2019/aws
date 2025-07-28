# Zip the Lambda function
variable "lambda_configs" {
  type = map(string)
  default = {
    notify_new_record       = "notify_new_record.py"
    purchase_capacity_block = "purchase_capacity_block.py"
    return_task_token       = "return_task_token.py"
    set_request_status      = "set_request_status.py"
    submit_approval_request = "submit_approval_request.py"
  }
}

data "archive_file" "lambda_zips" {
  for_each    = var.lambda_configs
  type        = "zip"
  source_file = "${path.module}/${each.value}"
  output_path = "${path.module}/build/${each.key}.zip"
}

# S3 Bucket
resource "aws_s3_bucket" "cqpocsbucket" {
  bucket = "mystepfunctionbucket002"
  force_destroy = true  # optional: allows deletion even if non-empty
  tags = {
    Name = "cqpocsbucket-1"
  }
}



# Upload zip file to S3
resource "aws_s3_object" "lambda_zips" {
  for_each      = var.lambda_configs
  bucket        = aws_s3_bucket.cqpocsbucket.id
  key           = "${each.key}.zip"
  source        = data.archive_file.lambda_zips[each.key].output_path
  etag          = filemd5(data.archive_file.lambda_zips[each.key].output_path)
  content_type  = "application/zip"
}


# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = file("LambdaFunction/lambda_assume_role_policy.json")
  lifecycle {
    prevent_destroy = true  # avoid accidental deletion
    ignore_changes  = all   # skip changes if role already exists
  }
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_role.id
  policy = file("LambdaFunction/lambda_policy.json")
}

# Lambda Function
resource "aws_lambda_function" "work_flow" {
  for_each = var.lambda_configs

  function_name    = each.key
  s3_bucket        = aws_s3_bucket.cqpocsbucket.id
  s3_key           = aws_s3_object.lambda_zips[each.key].key
  role             = aws_iam_role.lambda_role.arn
  handler          = "${each.key}.handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.lambda_zips[each.key].output_base64sha256

  depends_on = [aws_s3_object.lambda_zips]
}



# Output
output "pythonLambdaArn" {
  value = { for k, v in aws_lambda_function.work_flow : k => v.arn }
}
