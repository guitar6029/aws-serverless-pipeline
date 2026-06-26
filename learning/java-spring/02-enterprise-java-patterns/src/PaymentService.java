
public class PaymentService {

    private final PaymentRepository repository;

    public PaymentService(PaymentRepository repository) {
        this.repository = repository;
    }

    public void processPayment(Payment payment) {
        if (payment.getAmount() < 0) {
            throw new IllegalArgumentException("Payment amount cannot be negative");
        }

        System.out.println("Processing payment...");

        repository.save(payment);
    }

}
