# for payments root 
# resource "<resource_type>" "<local_name>"
resource "aws_api_gateway_resource" "payments" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  parent_id   = aws_api_gateway_rest_api.payments.root_resource_id
  path_part   = "payments"
}

# for payments
resource "aws_api_gateway_method" "get_payments" {
  rest_api_id   = aws_api_gateway_rest_api.payments.id
  resource_id   = aws_api_gateway_resource.payments.id
  http_method   = "GET"
  authorization = "NONE"
}


# for individual payment
resource "aws_api_gateway_resource" "payment_id" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  parent_id   = aws_api_gateway_resource.payments.id
  path_part   = "{payment_id}"
}

# method GET for single payment
resource "aws_api_gateway_method" "get_payment" {
  rest_api_id   = aws_api_gateway_rest_api.payments.id
  resource_id   = aws_api_gateway_resource.payment_id.id
  http_method   = "GET"
  authorization = "NONE"
}

# method POST for single payment
resource "aws_api_gateway_method" "post_payment" {
  rest_api_id   = aws_api_gateway_rest_api.payments.id
  resource_id   = aws_api_gateway_resource.payments.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

# integration for POST single payment
resource "aws_api_gateway_integration" "post_payment" {
  rest_api_id             = aws_api_gateway_rest_api.payments.id
  resource_id             = aws_api_gateway_resource.payments.id
  http_method             = aws_api_gateway_method.post_payment.http_method
  uri                     = module.create_payment_api.invoke_arn
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}

# integration for GET single payment
resource "aws_api_gateway_integration" "get_payment" {
  rest_api_id             = aws_api_gateway_rest_api.payments.id
  resource_id             = aws_api_gateway_resource.payment_id.id
  http_method             = aws_api_gateway_method.get_payment.http_method
  uri                     = module.payments_api.invoke_arn
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}

# integration for GET payments
resource "aws_api_gateway_integration" "get_payments" {
  rest_api_id             = aws_api_gateway_rest_api.payments.id
  resource_id             = aws_api_gateway_resource.payments.id
  http_method             = aws_api_gateway_method.get_payments.http_method
  uri                     = module.payments_api.invoke_arn
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}

