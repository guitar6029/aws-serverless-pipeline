package com.joshdev.telemetrydemo.service;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.joshdev.telemetrydemo.dto.drone.CreateDroneRequest;
import com.joshdev.telemetrydemo.model.Drone;
import com.joshdev.telemetrydemo.model.DroneStatus;
import com.joshdev.telemetrydemo.repository.DroneRepository;

@Service
public class DroneService {

    private final DroneRepository droneRepository;

    public DroneService(DroneRepository droneRepository) {
        this.droneRepository = droneRepository;
    }

    public Drone getDrone(UUID id) {
        return new Drone("example", DroneStatus.ONLINE, 94, 42.5);
    }

    public Drone createDrone(CreateDroneRequest request) {
        return new Drone(
                request.getName(),
                DroneStatus.OFFLINE,
                request.getBattery(),
                25.0
        );
    }

}
