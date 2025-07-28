##Zip the function to be run at function APP
data "archive_file" "init" {
    type = "zip"
    source_file = "${path.module}/notify-new-record.py"
    output_path = "${path.module}/notify-new-record.zip"


}

#S3 Bucket
resource "aws_s3_bucket" "cqpocsbucket"{
     bucket = "quickcloudpocsbucket001"
     acl    = "private"

     tags = {
        Name      = "cqpocsbucket-1"
     }
}

#Upload zip file to s3 bucket
resource "aws_s3_bucket_object" "object"{
   bucket = aws_s3_bucket.cqpocsbucket.id
   key = "notify-new-record.zip"
   source_file = "${path.module}/notify-new-record.py"
}

# IAM role-policy for Lambda
resource "aws_iam_role" "lambda_role"{
 name              = "lambda_role"
 assume_role_policy = file("LambdaFunction/lambda_assume_role_policy.json")
}

resource "aws_iam_role_policy" "lambda_policy"{
 name       = "lambda_policy"
 role       = aws_iam_role.lambda_role.id
 assume_role_policy = file("LambdaFunction/lambda_policy.json")
}

#Aws Lambda LambdaFunction

resource "aws_lambda_functions" "test_lambda"{
    function_name = "notify_new_record"
    s3_bucket     = aws_s3_bucket.cqpocsbucket.id
    s3_key        = "notify-new-record.zip"
    role          = aws_iam_role.lambda_role.arn
    handler       = "notify_new_record.handler"
    runtime       = "python3.8"
}


#output to be consumed by other module
output "pythonLambdaArn"{
 value = aws_lambda_functions.test_lambda
}