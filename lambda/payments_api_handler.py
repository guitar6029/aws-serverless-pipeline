import json

from repositories.payments import get_payment


def handler(event,context):
    
    payment_id = int(event["pathParameters"]["payment_id"])
    
    payment = get_payment(payment_id)
    
    if payment is None:
        return {
            "statusCode": 404,
            "body": json.dumps(
                {"message": "Payment not found"}
            ),
        }
        
    return {
        "statusCode": 200,
        "body": json.dumps(payment)
    }