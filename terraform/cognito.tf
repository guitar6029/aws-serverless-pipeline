resource "aws_cognito_user_pool" "payments" {
  name = "payments-user-pool"
}

resource "aws_cognito_user_pool_client" "payments" {
  name         = "payments-client"
  user_pool_id = aws_cognito_user_pool.payments.id


  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  generate_secret = false
}

resource "aws_api_gateway_authorizer" "cognito" {
  name          = "payments-cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.payments.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.payments.arn]
}