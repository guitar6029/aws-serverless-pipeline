from dataclasses import dataclass
from models.payment import PaymentStatus
from decimal import Decimal


@dataclass
class PaymentFilters:
    status: PaymentStatus | None = None
    company: str | None = None
    min_amount: Decimal | None = None
    max_amount: Decimal | None = None
