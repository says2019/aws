provider "aws" {
  region = "ap-south-1" # Mumbai region
}

resource "aws_dynamodb_table" "example" {
  name           = "SampleTable"
  billing_mode   = "PAY_PER_REQUEST" # No need to specify read/write capacity
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"  # S = String, N = Number, B = Binary
  }

  tags = {
    Environment = "Dev"
    Team        = "Analytics"
  }
}