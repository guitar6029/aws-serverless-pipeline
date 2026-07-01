package com.joshdev.telemetrydemo.service;

import org.springframework.stereotype.Service;
import com.joshdev.telemetrydemo.service.DroneService;

@Service
public class TelemetryService {

    private final DroneService droneService;

    public TelemetryService(DroneService droneService) {
        this.droneService = droneService;
    }

    public int getDroneServiceId() {
        return System.identityHashCode(droneService);
    }
}