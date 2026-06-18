
resource "aws_iam_role_policy" "reports_api_dynamodb_read" {
  name = "reports-api-dynamodb-read"

  role = aws_iam_role.reports_api_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        # "dynamodb:GetItem",
        "dynamodb:Scan",
        # "dynamodb:Query"
      ]
      Resource = [
        aws_dynamodb_table.payments.arn,
        "${aws_dynamodb_table.payments.arn}/index/*"
      ]
    }]
  })
}


resource "aws_iam_role" "reports_api_role" {
  name = "reports-api-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "reports_api_basic_execution" {
  role       = aws_iam_role.reports_api_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# END REPORTS

