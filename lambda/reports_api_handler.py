import json
from repositories.reports import get_all_payments
from collections import defaultdict
from decimal import Decimal


def handler(event, context):
    items = get_all_payments()

    totals = defaultdict(Decimal)

    for item in items:
        if "status" in item and "amount" in item:
            totals[item["status"]] += item["amount"]

    total_payments = len(items)

    total_amount = sum(item["amount"] for item in items if "amount" in item)

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "total_payments": total_payments,
                "total_amount": total_amount,
                "total_paid": totals.get("paid", Decimal("0")),
                "total_pending": totals.get("pending", Decimal("0")),
                "total_failed": totals.get("failed", Decimal("0")),
            },
            default=str,
        ),
    }
