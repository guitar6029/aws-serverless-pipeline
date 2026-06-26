
public class Cat {

    private final Sound sound;

    public Cat(Sound sound) {
        this.sound = sound;
    }

    public void makeSound() {
        sound.makeSound();
    }
}
