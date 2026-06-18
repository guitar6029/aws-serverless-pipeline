import json
from pydantic import ValidationError
from models.create_payment_request import CreatePaymentRequest
from botocore.exceptions import ClientError
from repositories.payments import enqueue_payment, create_payment_dict


def handler(event, context):
    if not event.get("body"):
        return {
            "statusCode": 400,
            "body": json.dumps({"message": "Missing request body"}),
        }

    try:
        body = json.loads(event["body"])
    except json.JSONDecodeError:
        return {"statusCode": 400, "body": json.dumps({"message": "Invalid JSON"})}

    try:
        request = CreatePaymentRequest.model_validate(body)
    except ValidationError as e:
        return {"statusCode": 400, "body": e.json()}

    # sqs for payment
    try:

        payment = create_payment_dict(request)
        enqueue_payment(payment)
    except ClientError:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to create payment"}),
        }

    # synchronous
    # return {"statusCode": 201, "body": json.dumps(payment, default=str)}

    # with sqs, we just return a message
    return {
        "statusCode": 202,
        "body": json.dumps(
            {
                "message": "Payment queued for processing",
                "payment_id": payment["payment_id"],
            }
        ),
    }
