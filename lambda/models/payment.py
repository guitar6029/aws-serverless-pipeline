from pydantic import BaseModel
from enum import Enum
from datetime import date


class PaymentStatus(str, Enum):
    PAID = "paid"
    PENDING = "pending"
    FAILED = "failed"


class Payment(BaseModel):
    payment_id: int
    client: str
    amount: float
    date: date
    status: PaymentStatus
