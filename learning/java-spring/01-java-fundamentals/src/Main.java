
public class Main {

    public static void main(String[] args) {
        Person person = new Person();

        person.name = "Mike";
        person.age = 35;

        System.out.println("Name : " + person.name);
        System.out.println("Age: " + person.age);

        Car teslaX = new Car("Tesla", "X", 2025);
        Car teslaY = new Car("Tesla", "Y", 2026);

        carDisplay(teslaX);
        System.out.println("----------------");
        carDisplay(teslaY);

        Sound meow = () -> System.out.println("Meow");
        Cat bean = new Cat(meow);

        Sound woof = () -> System.out.println("Woof");
        Dog rufus = new Dog(woof);

        bean.makeSound();
        rufus.makeSound();

    }

    public static void carDisplay(Car car) {

        System.out.println("Make : " + car.getMake());
        System.out.println("Model : " + car.getModel());
        System.out.println("Year : " + car.getYear());
    }

}
