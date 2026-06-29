package com.joshdev.telemetrydemo.service;

import com.joshdev.telemetrydemo.model.Drone;
import org.springframework.stereotype.Service;

@Service
public class DroneService {

    public Drone getDrone(String id) {
        return new Drone(id, "ONLINE", 94, 42.5);
    }
}
