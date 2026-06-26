
public class PaymentService {

    private final Printer printer;

    public PaymentService(Printer printer) {
        this.printer = printer;
    }

    public void checkout() {
        printer.print("Payment completed.");
    }
}
