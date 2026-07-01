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
        return droneRepository.findById(id).orElseThrow();
    }

    public Drone createDrone(CreateDroneRequest request) {

        Drone drone = new Drone(
                request.getName(),
                DroneStatus.OFFLINE,
                request.getBattery(),
                25.0
        );

        return droneRepository.save(drone);
    }

}
