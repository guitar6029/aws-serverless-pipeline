import json
from repositories.payments import get_payment, list_payments
from utils.payment_filters import parse_payment_filters
from utils.payment_response import payment_to_response


def handler(event, context):

    path_parameters = event.get("pathParameters") or {}

    if "payment_id" in path_parameters:

        payment_id = int(event["pathParameters"]["payment_id"])

        payment = get_payment(payment_id)

        if payment is None:
            return {
                "statusCode": 404,
                "body": json.dumps({"message": "Payment not found"}),
            }

        response = payment_to_response(payment)

        return {"statusCode": 200, "body": json.dumps(response)}
    else:

        try:
            filters = parse_payment_filters(event.get("queryStringParameters") or {})
        except ValueError:
            return {
                "statusCode": 400,
                "body": json.dumps({"message": "Invalid filters"}),
            }

        # items and last_key
        result = list_payments(filters)

        items = result["items"]
        last_key = result["last_key"]

        response = {
            "items": [payment_to_response(payment) for payment in items],
            "last_key": last_key,
        }

        return {"statusCode": 200, "body": json.dumps(response)}
