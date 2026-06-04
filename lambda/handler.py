def handler(event, context):
    print("Hello from Lambda")
    return {"statusCode": 200, "message": "Lambda executed successfully"}
