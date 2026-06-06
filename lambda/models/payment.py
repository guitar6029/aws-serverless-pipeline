from pydantic import BaseModel
from enum import Enum
from datetime import date
from decimal import Decimal


class PaymentStatus(str, Enum):
    PAID = "paid"
    PENDING = "pending"
    FAILED = "failed"


class Payment(BaseModel):
    payment_id: int
    client: str
    amount: Decimal
    date: date
    status: PaymentStatus
