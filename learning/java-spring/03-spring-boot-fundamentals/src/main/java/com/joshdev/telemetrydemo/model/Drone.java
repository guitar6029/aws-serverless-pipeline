package com.joshdev.telemetrydemo.model;

public class Drone {

    private String id;
    private String status;
    private int battery;
    private double temperature;

    public Drone(String id, String status, int battery, double temperature) {
        this.id = id;
        this.status = status;
        this.battery = battery;
        this.temperature = temperature;
    }

    @Override
    public String toString() {
        return "Drone\nID: " + id + "\nStatus: " + status + "\nBattery: " + battery + "\nTemperature: " + temperature + "\n";
    }

    public String getId() {
        return id;
    }

    public String getStatus() {
        return status;
    }

    public int getBattery() {
        return battery;
    }

    public double getTemperature() {
        return temperature;
    }
}
