module "demo_lambda" {
  source        = "../modules/lambda"
  function_name = "aws-serverless-pipeline-demo"
  role_arn      = aws_iam_role.lambda_role.arn
  handler       = "ingestion_handler.handler"
  filename      = "../lambda/handler.zip"

  dead_letter_target_arn = aws_sqs_queue.ingestion_dlq.arn
}

module "reports_api" {
  source        = "../modules/lambda"
  function_name = "reports-api"
  role_arn      = aws_iam_role.reports_api_role.arn
  handler       = "reports_api_handler.handler"
  filename      = "../lambda/handler.zip"
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = module.demo_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.demo.arn

}

module "payments_api" {
  source        = "../modules/lambda"
  function_name = "payments-api"
  role_arn      = aws_iam_role.payments_api_role.arn
  handler       = "payments_api_handler.handler"
  filename      = "../lambda/handler.zip"
}

resource "aws_lambda_permission" "allow_payments_api" {
  statement_id = "AllowExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = module.payments_api.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"
}