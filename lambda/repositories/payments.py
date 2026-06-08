import boto3
from boto3.dynamodb.conditions import Attr

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("payments")


def save_payment(payment):
    table.put_item(Item=payment.model_dump(mode="json"))


def get_payment(payment_id: int):
    response = table.get_item(Key={"payment_id": payment_id})

    item = response.get("Item")

    if item is None:
        return None

    item["payment_id"] = int(item["payment_id"])

    return item


def list_payments(status=None):

    if status is not None:
        response = table.scan(FilterExpression=Attr("status").eq(status))
    else:
        response = table.scan()

    items = response.get("Items", [])

    for item in items:
        item["payment_id"] = int(item["payment_id"])

    return items
