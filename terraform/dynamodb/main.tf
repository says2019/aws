
resource "aws_dynamodb_table" "user_table" {
  name           = "Capacity2"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Name        = "Capacity2"
    Environment = "dev"
  }

lifecycle {
    prevent_destroy = true
    ignore_changes = [
      read_capacity,
      write_capacity,
      tags
    ]
  }
}