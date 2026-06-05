resource "aws_s3_bucket" "demo" {
  bucket = "jsdev305-aws-serverless-pipeline-demo"

  tags = {
    Environment = "dev"
    Project     = "aws-serverless-pipeline"
    ManagedBy   = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id
  rule {
    id     = "cleanup-old-objects"
    status = "Enabled"

    expiration {
      days = 365
    }
  }
}
