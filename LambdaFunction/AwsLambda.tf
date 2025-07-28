# Zip the Lambda function
data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/notify-new-record.py"
  output_path = "${path.module}/notify-new-record.zip"
}

# S3 Bucket
resource "aws_s3_bucket" "cqpocsbucket" {
  bucket = "quickcloudpocsbucket001"
  force_destroy = true  # optional: allows deletion even if non-empty
  tags = {
    Name = "cqpocsbucket-1"
  }
}

resource "aws_s3_bucket_acl" "private_acl" {
  bucket = aws_s3_bucket.cqpocsbucket.id
  acl    = "private"
}

# Upload zip file to S3
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.cqpocsbucket.id
  key    = "notify-new-record.zip"
  source = data.archive_file.init.output_path
  etag   = filemd5(data.archive_file.init.output_path)
  content_type = "application/zip"
}


# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = file("LambdaFunction/lambda_assume_role_policy.json")
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_role.id
  policy = file("LambdaFunction/lambda_policy.json")
}

# Lambda Function
resource "aws_lambda_function" "test_lambda" {
  function_name    = "notify_new_record"
  s3_bucket        = aws_s3_bucket.cqpocsbucket.id
  s3_key           = aws_s3_object.lambda_zip.id
  role             = aws_iam_role.lambda_role.arn
  handler          = "notify-new-record.handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.init.output_base64sha256
}


# Output
output "pythonLambdaArn" {
  value = aws_lambda_function.test_lambda.arn
}
