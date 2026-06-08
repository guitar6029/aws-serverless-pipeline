# for newer projects
# resource "aws_apigatewayv2_api" "payments" {
#   name                       = "payments-api"
#   protocol_type              = "HTTP"
# }

# for learning purposes pick v1
resource "aws_api_gateway_rest_api" "payments" {
  name = "payments-api"
}

# for payments root
# resource "<resource_type>" "<local_name>"
resource "aws_api_gateway_resource" "payments" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  parent_id   = aws_api_gateway_rest_api.payments.root_resource_id
  path_part   = "payments"
}

#for individual payment
resource "aws_api_gateway_resource" "payment_id" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  parent_id   = aws_api_gateway_resource.payments.id
  path_part   = "{payment_id}"
}

resource "aws_api_gateway_method" "get_payments" {
  rest_api_id   = aws_api_gateway_rest_api.payments.id
  resource_id   = aws_api_gateway_resource.payments.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "get_payment" {
  rest_api_id = aws_api_gateway_rest_api.payments.id

  resource_id = aws_api_gateway_resource.payment_id.id

  http_method = "GET"

  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_payments" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  resource_id = aws_api_gateway_resource.payments.id
  http_method = aws_api_gateway_method.get_payments.http_method

  uri = aws_lambda_function.payments_api.invoke_arn

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}


resource "aws_api_gateway_integration" "get_payment" {
  rest_api_id             = aws_api_gateway_rest_api.payments.id
  resource_id             = aws_api_gateway_resource.payment_id.id
  http_method             = aws_api_gateway_method.get_payment.http_method
  uri                     = aws_lambda_function.payments_api.invoke_arn
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_deployment" "payments" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "payments" {
  deployment_id = aws_api_gateway_deployment.payments.id

  rest_api_id = aws_api_gateway_rest_api.payments.id

  stage_name = "dev"
}