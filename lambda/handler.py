import boto3


def handler(event, context):

    s3 = boto3.client("s3")

    record = event["Records"][0]

    bucket_name = record["s3"]["bucket"]["name"]
    object_key = record["s3"]["object"]["key"]

    response = s3.get_object(Bucket=bucket_name, Key=object_key)

    # For this learning project we read the entire object into memory.
    # This is acceptable for small text files, but large files should be
    # streamed and processed incrementally.
    content = response["Body"].read().decode("utf-8")

    print(f"Bucket: {bucket_name}")
    print(f"Object: {object_key}")

    print("File contents:")
    print(content)

    return {"statusCode": 200}
