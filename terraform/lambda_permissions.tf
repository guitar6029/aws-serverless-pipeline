resource "aws_lambda_permission" "allow_payments_api" {
  statement_id = "AllowPaymentsExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = module.payments_api.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"
}


resource "aws_lambda_permission" "allow_create_payment_api" {
  statement_id = "AllowCreatePaymentExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = module.create_payment_api.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"
}


resource "aws_lambda_permission" "allow_payments_api_v2" {
  statement_id = "AllowPaymentsExecutionFromAPIGatewayV2"

  action = "lambda:InvokeFunction"

  function_name = module.payments_api_v2.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"
}


resource "aws_lambda_permission" "allow_reports_api" {
  statement_id = "AllowReportsExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = module.reports_api.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.payments.execution_arn}/*"

}


resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = module.demo_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.demo.arn

}