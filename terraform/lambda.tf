resource "aws_lambda_function" "demo" {
  function_name = "aws-serverless-pipeline-demo"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.12"

  handler = "handler.handler"

  filename = "../lambda/handler.zip"

  source_code_hash = filebase64sha256("../lambda/handler.zip")

  timeout     = 5
  memory_size = 128
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.demo.arn

}

