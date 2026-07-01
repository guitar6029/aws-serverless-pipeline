
public class Dog {

    private final Sound sound;

    public Dog(Sound sound) {
        this.sound = sound;
    }

    public void makeSound() {
        sound.makeSound();
    }
}
