resource "aws_sqs_queue" "payment_creation_queue" {
  name = "payment-creation-queue"
}