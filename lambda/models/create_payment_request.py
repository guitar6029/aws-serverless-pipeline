from pydantic import BaseModel, Field
from enum import Enum
from datetime import date
from decimal import Decimal
from models.payment import PaymentStatus


class CreatePaymentRequest(BaseModel):
    amount: Decimal = Field(gt=0)
    client: str
    date: date
    status: PaymentStatus
