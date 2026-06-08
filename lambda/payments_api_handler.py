import json

from repositories.payments import get_payment, list_payments
from models.payment import PaymentStatus


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
        query_params = event.get("queryStringParameters")

        status: PaymentStatus | None = None

        if query_params:
            status_param = query_params.get("status")

            if status_param is not None:
                try:
                    status = PaymentStatus(status_param)
                except ValueError:
                    return {
                        "statusCode": 400,
                        "body": json.dumps({"message": "Invalid status"}),
                    }

        payments = list_payments(status)

        return {"statusCode": 200, "body": json.dumps(payments)}
