resource "aws_dynamodb_table" "payments" {
  name         = "payments"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "payment_id"
  attribute {
    name = "payment_id"
    type = "N"
  }
}
