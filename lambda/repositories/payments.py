import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("payments")


def save_payment(payment):
    table.put_item(Item=payment.model_dump(mode="json"))
