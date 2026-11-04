resource "aws_sqs_queue" "payment_creation_queue" {
  name                      = "payment-creation-queue"
  receive_wait_time_seconds = 20
}

resource "aws_lambda_event_source_mapping" "payment_worker" {
  event_source_arn = aws_sqs_queue.payment_creation_queue.arn

  function_name = module.payment_worker.function_name

  batch_size = 1
  enabled    = var.enable_payment_worker
}
