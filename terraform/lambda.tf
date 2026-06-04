resource "aws_iam_role" "lambda_role" {
  name = "aws-serverless-pipeline-lambda-role"

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

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "demo" {
  function_name = "aws-serverless-pipeline-demo"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.13"

  handler = "handler.handler"

  filename = "../lambda/handler.zip"

  source_code_hash = filebase64sha256("../lambda/handler.zip")

  timeout     = 5
  memory_size = 128
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.demo.arn

}

resource "aws_s3_bucket_notification" "demo" {
  bucket = aws_s3_bucket.demo.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.demo.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}


resource "aws_iam_role_policy" "lambda_s3_read" {
  name = "lambda-s3-read"

  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = [
          "${aws_s3_bucket.demo.arn}/*"
        ]
      }
    ]
  })
}

