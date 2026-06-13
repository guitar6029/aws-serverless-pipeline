resource "aws_lambda_function" "this" {
    function_name = var.function_name

    role = var.role_arn

    runtime = "python3.12"

    handler = var.handler

    filename = var.filename

    source_code_hash = filebase64sha256(var.filename)

    timeout = 5
    memory_size = 128
}