from models.payment import Payment


def parse_payment_row(row: str) -> Payment:
    values = row.strip().split(",")
    return Payment(
        payment_id=int(values[0]),
        client=values[1].strip(),
        amount=float(values[2]),
        date=values[3],
        status=values[4].lower(),
    )
