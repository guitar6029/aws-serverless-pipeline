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

    if filter_expressions is None:
        response = table.scan()
    else:
        # feed the expression into the table if has at least one query
        response = table.scan(FilterExpression=filter_expressions)

    # extract items
    items = response.get("Items", [])

    for item in items:
        # format the payment_id
        item["payment_id"] = int(item["payment_id"])

    return items
