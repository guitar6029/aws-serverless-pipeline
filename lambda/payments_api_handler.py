import json

from repositories.payments import get_payment, list_payments


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

        return {"statusCode": 200, "body": json.dumps(payment)}
    else:
        payments = list_payments()

        return {"statusCode": 200, "body": json.dumps(payments)}
