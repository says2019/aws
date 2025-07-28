provider "aws" {
  region = "us-east-1"
}

# S3 bucket for backend state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "cloudquickpocsbackendtf"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }

  force_destroy = true
}

# Enable versioning (recommended for state file protection)
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional: DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Locks"
    Environment = "Dev"
  }
}
