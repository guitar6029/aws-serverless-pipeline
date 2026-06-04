import json


def handler(event, context):
    print("Lambda invoked")

    print(json.dumps(event, indent=2))

    return {"statusCode": 200, "message": "Success"}
