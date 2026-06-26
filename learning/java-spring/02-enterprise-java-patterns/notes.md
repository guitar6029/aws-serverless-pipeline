## Layer Responsibilities

### Main
Responsible for creating and wiring the application.

### Payment
Represents domain data.

### PaymentRepository
Defines the persistence contract.

### InMemoryPaymentRepository
Implements persistence.

### PaymentService
Contains business logic and delegates persistence to the repository.