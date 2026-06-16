import json
from repositories.reports import get_all_payments
from collections import defaultdict
from decimal import Decimal


def handler(event, context):
    items = get_all_payments()

    totals = defaultdict(Decimal)
    amount_totals = defaultdict(Decimal)
    status_counts = defaultdict(int)

    for item in items:
        if "status" in item and "amount" in item:
            totals[item["status"]] += item["amount"]

    total_payments = len(items)

    total_amount = sum(item["amount"] for item in items if "amount" in item)

    for item in items:
        if "status" in item:
            status_counts[item["status"]] += 1
        if "status" in item and "amount" in item:
            amount_totals[item["status"]] += item["amount"]

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "total_payments": total_payments,
                "total_amount": total_amount,
                "paid_count": status_counts.get("paid", 0),
                "pending_count": status_counts.get("pending", 0),
                "failed_count": status_counts.get("failed", 0),
                "total_paid": amount_totals.get("paid", Decimal("0")),
                "total_pending": amount_totals.get("pending", Decimal("0")),
                "total_failed": amount_totals.get("failed", Decimal("0")),
            },
            default=str,
        ),
    }
