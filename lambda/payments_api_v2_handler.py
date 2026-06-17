import json


def handler(event, context):
    print("V2 EVENT:")
    print(json.dumps(event))
    return {"statusCode": 200, "body": json.dumps({"message": "payments v2 working"})}
