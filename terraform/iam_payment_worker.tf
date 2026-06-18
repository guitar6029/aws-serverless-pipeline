resource "aws_iam_role" "payment_worker_role" {
  name = "payment-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "payment_worker_dynamodb_write" {
  name = "payment-worker-dynamodb-write"

  role = aws_iam_role.payment_worker_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "dynamodb:PutItem"
      ]

      Resource = [
        aws_dynamodb_table.payments.arn
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "payment_worker_basic_execution" {
  role       = aws_iam_role.payment_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "payment_worker_sqs" {
  role = aws_iam_role.payment_worker_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}
