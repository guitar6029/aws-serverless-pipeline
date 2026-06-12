resource "aws_cloudwatch_metric_alarm" "payments_api_errors" {
  alarm_name        = "payments-api-errors" # Fixed from alert_name
  alarm_description = "Triggers if the payments-api Lambda throws any errors"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"

  comparison_operator = "GreaterThanThreshold"
  threshold           = 0

  period             = 300
  evaluation_periods = 1

  # Sum counts total errors in the 5-minute window
  statistic = "Sum"

  dimensions = {
    FunctionName = aws_lambda_function.payments_api.function_name
  }
}