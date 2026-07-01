package com.joshdev.telemetrydemo.model;

import java.util.UUID;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
public class Drone {

    private final String name;

    @Id
    @GeneratedValue
    private UUID id;

    private final DroneStatus status;
    private final int battery;
    private final double temperature;

    public Drone(String name, DroneStatus status, int battery, double temperature) {

        this.name = name;
        this.status = status;
        this.battery = battery;
        this.temperature = temperature;
    }

    @Override
    public String toString() {
        return "Drone\nName:" + name + "\nID: " + id + "\nStatus: " + status + "\nBattery: " + battery + "\nTemperature: " + temperature + "\n";
    }

    public String getName() {
        return name;
    }

    public UUID getId() {
        return id;
    }

    public DroneStatus getStatus() {
        return status;
    }

    public int getBattery() {
        return battery;
    }

    public double getTemperature() {
        return temperature;
    }
}
