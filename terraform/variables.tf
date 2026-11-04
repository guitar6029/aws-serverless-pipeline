variable "enable_payment_worker" {
  description = "Enable Lambda polling of the payment creation SQS queue"
  type        = bool
  default     = false
}
