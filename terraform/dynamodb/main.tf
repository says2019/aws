provider "aws" {
  region = "us-east-1"  # or your preferred region
}

resource "aws_dynamodb_table" "user_table" {
  name           = "user"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Name        = "user-table"
    Environment = "dev"
  }
}
