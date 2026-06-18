#for reports
resource "aws_api_gateway_resource" "reports" {
  rest_api_id = aws_api_gateway_rest_api.payments.id

  parent_id = aws_api_gateway_rest_api.payments.root_resource_id

  path_part = "reports"
}

resource "aws_api_gateway_method" "get_reports" {
  rest_api_id   = aws_api_gateway_rest_api.payments.id
  resource_id   = aws_api_gateway_resource.reports.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_reports" {
  rest_api_id = aws_api_gateway_rest_api.payments.id
  resource_id = aws_api_gateway_resource.reports.id
  http_method = aws_api_gateway_method.get_reports.http_method

  uri = module.reports_api.invoke_arn

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}

