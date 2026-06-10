from models.payment import PaymentStatus
from models.payment_filter import PaymentFilters
from decimal import Decimal


def parse_payment_filters(query_params: dict[str, str]) -> PaymentFilters:

    filters = PaymentFilters()

    status_param = query_params.get("status")

    if status_param:
        filters.status = PaymentStatus(status_param)

    company_param = query_params.get("company")

    if company_param:
        filters.company = company_param

    min_amount_param = query_params.get("min_amount")

    if min_amount_param:
        filters.min_amount = Decimal(min_amount_param)

    max_amount_param = query_params.get("max_amount")

    if max_amount_param:
        filters.max_amount = Decimal(max_amount_param)

    return filters
