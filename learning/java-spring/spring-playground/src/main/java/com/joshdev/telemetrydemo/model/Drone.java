package com.joshdev.telemetrydemo.model;

public class Drone {

    private final String name;
    private final String id;
    private final DroneStatus status;
    private final int battery;
    private final double temperature;

    public Drone(String id, String name, DroneStatus status, int battery, double temperature) {
        this.id = id;
        this.name = name;
        this.status = DroneStatus.OFFLINE;
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

    public String getId() {
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
