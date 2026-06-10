def payment_to_response(payment: dict) -> dict:
    return {
        "payment_id": payment["payment_id"],
        "amount": float(payment["amount"]),
        "client": payment["client"],
        "date": payment["date"],
        "status": payment["status"],
    }
