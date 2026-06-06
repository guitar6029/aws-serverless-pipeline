import boto3
from processors.payments import parse_payment_row
from repositories.payments import save_payment


def handler(event, context):

    s3 = boto3.client("s3")

    record = event["Records"][0]

    bucket_name = record["s3"]["bucket"]["name"]
    object_key = record["s3"]["object"]["key"]

    response = s3.get_object(Bucket=bucket_name, Key=object_key)

    print(f"Bucket: {bucket_name}")
    print(f"Object: {object_key}")

    first_row = True

    for line in response["Body"].iter_lines():
        decoded_line = line.decode("utf-8").strip()
        if not decoded_line:
            continue
        # skip the header row
        if first_row:
            first_row = False
            continue
        payment = parse_payment_row(decoded_line)
        save_payment(payment)

    return {"statusCode": 200}
