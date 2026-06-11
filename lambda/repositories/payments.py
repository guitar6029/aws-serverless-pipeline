import boto3
from boto3.dynamodb.conditions import Attr
from models.payment_filter import PaymentFilters

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("payments")


def save_payment(payment):
    item = {
        "payment_id": payment.payment_id,
        "client": payment.client,
        "amount": payment.amount,
        "date": payment.date.isoformat(),
        "status": payment.status.value,
    }

    table.put_item(Item=item)


def get_payment(payment_id: int):
    response = table.get_item(Key={"payment_id": payment_id})

    item = response.get("Item")

    if item is None:
        return None

    item["payment_id"] = int(item["payment_id"])

    return item


def build_filter_expression(filters: PaymentFilters):
    expression = None
    conditions = []

    if filters.status:
        conditions.append(Attr("status").eq(filters.status.value))
    if filters.client:
        conditions.append(Attr("client").eq(filters.client))

    if filters.min_amount:
        conditions.append(Attr("amount").gte(filters.min_amount))

    if filters.max_amount:
        conditions.append(Attr("amount").lte(filters.max_amount))

    if not conditions:
        return None

    expression = conditions[0]

    for condition in conditions[1:]:
        expression = expression & condition

    return expression


def list_payments(filters: PaymentFilters):

    # first build the query expression
    filter_expressions = build_filter_expression(filters)

    scan_kwargs = {}

    if filters.limit:
        scan_kwargs["Limit"] = filters.limit

    if filter_expressions:
        scan_kwargs["FilterExpression"] = filter_expressions

    if filters.last_key:
        scan_kwargs["ExclusiveStartKey"] = {"payment_id": filters.last_key}

    response = table.scan(**scan_kwargs)

    # grab last key
    last_key = response.get("LastEvaluatedKey")

    cursor = None

    if last_key:
        cursor = int(last_key["payment_id"])

    items = response.get("Items", [])

    for item in items:
        # format the payment_id
        item["payment_id"] = int(item["payment_id"])

    # return items and last key
    return {"items": items, "last_key": cursor}
