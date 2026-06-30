package com.joshdev.telemetrydemo.dto.drone;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;

// traditional way
public class CreateDroneRequest {

    @NotBlank
    private String name;

    @Min(0)
    @Max(100)
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
