terraform {
  backend "s3" {
#     bucket         = "my-terraform-states"
#     key            = "iam/role/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# IAM Role
resource "aws_iam_role" "example_role" {
  name = "example-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Policy
resource "aws_iam_role_policy_attachment" "example_attach" {
  role       = aws_iam_role.example_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

output "role_name" {
  value = aws_iam_role.example_role.name
}




  #Create Aws Python lambda function
  module "awslambdafunction"{
    source = "./LambdaFunction"
  }


  #Create aws stepfunction to Inovke aws Lambda function
  module "awsstepfunction"{
   source =  "./StepFunction"
   pythonfunctionapparn = module.awslambdafunction.pythonLambdaArn
#   }