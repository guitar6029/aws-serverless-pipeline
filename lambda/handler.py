import json


def handler(event, context):

    record = event["Records"][0]

    bucket_name = record["s3"]["bucket"]["name"]

    object_key = record["s3"]["object"]["key"]

    print(f"Bucket: {bucket_name}")
    print(f"Object: {object_key}")

    return {"statusCode": 200}
