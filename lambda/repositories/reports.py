import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("payments")


def get_all_payments():
    response = table.scan()

    return response.get("Items", [])
