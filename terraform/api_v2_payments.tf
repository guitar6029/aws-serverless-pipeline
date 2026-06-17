#v2 payments api new "folder" sibling to /payments and reports
resource "aws_api_gateway_resource" "v2" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  parent_id   = aws_api_gateway_rest_api.payments.root_resource_id
  path_part   = "v2"
}

# for the v2/payments
resource "aws_api_gateway_resource" "v2_payments" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  parent_id   = aws_api_gateway_resource.v2.id
  path_part   = "payments"
}

#for the v2/payments{payment_id}
resource "aws_api_gateway_resource" "v2_payment_id" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  parent_id   = aws_api_gateway_resource.v2_payments.id
  path_part   = "{payment_id}"
}

#for v2/payments GET
resource "aws_api_gateway_method" "get_payments_v2" {
  rest_api_id   = aws_api_gateway_rest_api.payments.id
  resource_id   = aws_api_gateway_resource.v2_payments.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

#for v2/payments/{payments_id} GET
resource "aws_api_gateway_method" "get_payment_v2" {
  rest_api_id   = aws_api_gateway_rest_api.payments.id
  resource_id   = aws_api_gateway_resource.v2_payment_id.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}


resource "aws_api_gateway_integration" "get_payments_v2" {
  rest_api_id = aws_api_gateway_rest_api.payments.id

  resource_id = aws_api_gateway_resource.v2_payments.id

  http_method = aws_api_gateway_method.get_payments_v2.http_method

  uri = module.payments_api_v2.invoke_arn

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}

resource "aws_api_gateway_integration" "get_payment_v2" {
  rest_api_id = aws_api_gateway_rest_api.payments.id

  resource_id = aws_api_gateway_resource.v2_payment_id.id

  http_method = aws_api_gateway_method.get_payment_v2.http_method

  uri = module.payments_api_v2.invoke_arn

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}