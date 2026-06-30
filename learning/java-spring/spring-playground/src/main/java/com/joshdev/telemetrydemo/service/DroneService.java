package com.joshdev.telemetrydemo.service;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.joshdev.telemetrydemo.dto.drone.CreateDroneRequest;
import com.joshdev.telemetrydemo.model.Drone;
import com.joshdev.telemetrydemo.model.DroneStatus;

@Service
public class DroneService {

    public Drone getDrone(String id) {
        return new Drone(id, "example", DroneStatus.ONLINE, 94, 42.5);
    }

    public Drone createDrone(CreateDroneRequest request) {
        return new Drone(
                UUID.randomUUID().toString(),
                request.getName(),
                DroneStatus.OFFLINE,
                request.getBattery(),
                25.0
        );
    }
}
