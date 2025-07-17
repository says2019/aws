provider "aws" {
  region = "us-east-1" # change to your preferred region
}

resource "aws_dynamodb_table" "example_table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # On-demand billing

  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = var.table_name
    Environment = "dev"
  }
}
