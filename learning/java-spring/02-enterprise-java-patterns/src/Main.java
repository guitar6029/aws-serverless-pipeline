
public class Main {

    public static void main(String[] args) {

        PaymentRepository repository = new InMemoryPaymentRepository();

        PaymentService paymentService = new PaymentService(repository);

        Payment payment = new Payment(1, 249.99);

        paymentService.processPayment(payment);
    }
}
