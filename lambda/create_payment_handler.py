import json
from pydantic import ValidationError
from models.create_payment_request import CreatePaymentRequest
import boto3
from botocore.exceptions import ClientError
from repositories.payments import add_payment

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("payments")


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
    # validate the body params through a Model
    # CreatePaymentRequest

    try:
        request = CreatePaymentRequest.model_validate(body)
    except ValidationError as e:
        return {"statusCode": 400, "body": e.json()}

    # try to add new payment to the table
    try:
        payment = add_payment(request)
    except ClientError:
        return {
            "statusCode": 500,
            "body": json.dumps({"message": "Failed to create payment"}),
        }

    # if good then return the pamyent (the exact record from the dynamo)
    return {"statusCode": 201, "body": json.dumps(payment, default=str)}
