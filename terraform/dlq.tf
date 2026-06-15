resource "aws_sqs_queue" "ingestion_dlq" {
  name = "ingestion-dlq"
}