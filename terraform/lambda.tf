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

# version 1 payments_api_v1
module "payments_api" {
  source        = "../modules/lambda"
  function_name = "payments-api"
  role_arn      = aws_iam_role.payments_api_role.arn
  handler       = "payments_api_handler.handler"
  filename      = "../lambda/handler.zip"
}

module "create_payment_api" {
  source        = "../modules/lambda"
  function_name = "create-payment-api"
  role_arn      = aws_iam_role.payments_api_role.arn
  handler       = "create_payment_handler.handler"
  filename      = "../lambda/handler.zip"
}

module "payment_worker" {
  source        = "../modules/lambda"
  function_name = "payment-worker"
  role_arn      = aws_iam_role.payment_worker_role.arn
  handler       = "payment_worker_handler.handler"
  filename      = "../lambda/handler.zip"
}


# version 2 payments_api_v2
module "payments_api_v2" {
  source        = "../modules/lambda"
  function_name = "payments-api-v2"
  role_arn      = aws_iam_role.payments_api_role.arn
  handler       = "payments_api_v2_handler.handler"
  filename      = "../lambda/handler.zip"
}

resource "aws_lambda_permission" "allow_payments_api" {
  statement_id = "AllowPaymentsExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = module.payments_api.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"
}

# allow create payment
resource "aws_lambda_permission" "allow_create_payment_api" {
  statement_id = "AllowCreatePaymentExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = module.create_payment_api.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"
}

#v2 payments api
resource "aws_lambda_permission" "allow_payments_api_v2" {
  statement_id = "AllowPaymentsExecutionFromAPIGatewayV2"

  action = "lambda:InvokeFunction"

  function_name = module.payments_api_v2.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"
}


# reports
resource "aws_lambda_permission" "allow_reports_api" {
  statement_id = "AllowReportsExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = module.reports_api.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"

}
