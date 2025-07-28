#this is my lamdfa                    hhhhhhhhhhhhhhh
# Zip the Lambda function
data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/notify-new-record.py"
  output_path = "${path.module}/notify-new-record.zip"
}

# S3 Bucket
resource "aws_s3_bucket" "cqpocsbucket" {
  bucket = "stepfunctionbucket001"
  force_destroy = true  # optional: allows deletion even if non-empty
  tags = {
    Name = "cqpocsbucket-1"
  }
}
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

# Upload zip file to S3
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.cqpocsbucket.id
  key    = "notify-new-record.zip"
  source = data.archive_file.init.output_path
  etag   = filemd5(data.archive_file.init.output_path)
  content_type = "application/zip"

}

resource "aws_lambda_function" "lambda_functions" {
  for_each = toset(var.lambda_names)
  function_name    = each.key
  s3_bucket        = aws_s3_bucket.cqpocsbucket.id
  s3_key           = aws_s3_object.lambda_zip.key
  role             = aws_iam_role.lambda_role.arn
  handler          = "${replace(each.key, "_", "-")}.handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.init.output_base64sha256
  depends_on = [aws_s3_object.lambda_zip]
}

# Output
output "pythonLambdaArn" {
  value = aws_lambda_function.test_lambda.arn
}