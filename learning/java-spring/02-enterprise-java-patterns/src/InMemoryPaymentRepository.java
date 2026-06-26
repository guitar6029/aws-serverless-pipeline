
public class InMemoryPaymentRepository implements PaymentRepository {

    @Override
    public void save(Payment payment) {
        System.out.println("Saving payment $" + payment.getAmount());
    }
}
