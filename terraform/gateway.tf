# for newer projects
# resource "aws_apigatewayv2_api" "payments" {
#   name                       = "payments-api"
#   protocol_type              = "HTTP"
# }

# for learning purposes pick v1
resource "aws_api_gateway_rest_api" "payments" {
  name = "payments-api"
}


resource "aws_api_gateway_deployment" "payments" {
  rest_api_id = aws_api_gateway_rest_api.payments.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.payments.id,
      aws_api_gateway_resource.payment_id.id,
      aws_api_gateway_resource.reports.id,

      aws_api_gateway_method.get_payments.id,
      aws_api_gateway_method.get_payment.id,
      aws_api_gateway_method.get_reports.id,

      aws_api_gateway_integration.get_payments.id,
      aws_api_gateway_integration.get_payment.id,
      aws_api_gateway_integration.get_reports.id,


      aws_api_gateway_resource.v2.id,
      aws_api_gateway_resource.v2_payments.id,

      aws_api_gateway_method.get_payments_v2.id,

      aws_api_gateway_integration.get_payments_v2.id,
      aws_api_gateway_integration.get_payment_v2.id,

      # cognito authorizer
      aws_api_gateway_authorizer.cognito.id,


      # POST PAYMENT
      aws_api_gateway_method.post_payment.id,
      aws_api_gateway_integration.post_payment.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "payments" {
  deployment_id = aws_api_gateway_deployment.payments.id

  rest_api_id = aws_api_gateway_rest_api.payments.id

  stage_name = "dev"
}