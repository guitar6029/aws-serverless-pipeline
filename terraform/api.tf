# for newer projects
# resource "aws_apigatewayv2_api" "payments" {
#   name                       = "payments-api"
#   protocol_type              = "HTTP"
# }

#for learning purposes pick v1
resource "aws_api_gateway_rest_api" "payments" {
 name = "payments-api"
}