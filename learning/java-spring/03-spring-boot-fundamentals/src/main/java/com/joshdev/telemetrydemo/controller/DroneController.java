package com.joshdev.telemetrydemo.controller;

import com.joshdev.telemetrydemo.model.Drone;
import com.joshdev.telemetrydemo.service.DroneService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.joshdev.telemetrydemo.service.TelemetryService;

@RestController
@RequestMapping("/api/v1/drones")
public class DroneController {

    private final DroneService droneService;
    private final TelemetryService telemetryService;

    public DroneController(DroneService droneService, TelemetryService telemetryService) {
        this.droneService = droneService;
        this.telemetryService = telemetryService;
    }

    @GetMapping("/{id}")
    public Drone getDrone(@PathVariable String id) {
        return droneService.getDrone(id);
    }

@GetMapping("/service")
public String getSingleton() {

    return """
        DroneController DroneService: %d
        TelemetryService DroneService: %d
        """.formatted(
            System.identityHashCode(droneService),
            telemetryService.getDroneServiceId()
        );
}

}
