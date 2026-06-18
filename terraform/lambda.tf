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


module "payments_api_v2" {
  source        = "../modules/lambda"
  function_name = "payments-api-v2"
  role_arn      = aws_iam_role.payments_api_role.arn
  handler       = "payments_api_v2_handler.handler"
  filename      = "../lambda/handler.zip"
}
