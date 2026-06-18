import json
from repositories.payments import add_payment_to_db


def handler(event, context):
    for record in event["Records"]:
        payment = json.loads(record["body"])
        add_payment_to_db(payment)

    return {"statusCode": 200, "body": json.dumps({"message": "processed"})}
