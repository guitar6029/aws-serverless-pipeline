resource "aws_s3_bucket_notification" "demo" {
  bucket = aws_s3_bucket.demo.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.demo.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}