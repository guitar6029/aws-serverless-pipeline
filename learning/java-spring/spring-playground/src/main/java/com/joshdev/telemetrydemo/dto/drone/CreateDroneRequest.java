package com.joshdev.telemetrydemo.dto.drone;

// traditional way
public class CreateDroneRequest {

    private String name;
    private int battery;

    public CreateDroneRequest() {
    }

    public CreateDroneRequest(String name, int battery) {

        this.name = name;
        this.battery = battery;
    }

    public String getName() {
        return name;
    }

    public int getBattery() {
        return battery;
    }

}

// modern way 
// public record CreateDroneRequest(
//     String name,
//     int battery
// ) {}
