import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("payments")


def save_payment(payment):
    table.put_item(Item=payment.model_dump(mode="json"))


def get_payment(payment_id: int):
    response = table.get_item(
        Key={
            "payment_id": payment_id
        }
    )
    
    item = response.get("Item")
    
    if item is None:
        return None
    
    item["payment_id"] = int(item["payment_id"])
    
    
    return item