package com.joshdev.telemetrydemo.controller;

import java.util.UUID;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.joshdev.telemetrydemo.dto.drone.CreateDroneRequest;
import com.joshdev.telemetrydemo.model.Drone;
import com.joshdev.telemetrydemo.model.EmailClient;
import com.joshdev.telemetrydemo.service.DroneService;
import com.joshdev.telemetrydemo.service.TelemetryService;

@RestController
@RequestMapping("/api/v1/drones")
public class DroneController {

    private final DroneService droneService;
    private final TelemetryService telemetryService;
    private final EmailClient emailClient;

    public DroneController(DroneService droneService, TelemetryService telemetryService, EmailClient emailClient) {
        this.droneService = droneService;
        this.telemetryService = telemetryService;
        this.emailClient = emailClient;
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

    @GetMapping("/ping")
    public String getPing() {
        return emailClient.ping();
    }

    @GetMapping("/search")
    public String searchDrones(
            @RequestParam String status,
            @RequestParam int page
    ) {
        return "status=%s page%d".formatted(status, page);
    }

    @PostMapping
    public Drone createDrone(
            @RequestBody CreateDroneRequest request
    ) {
        String name = validateName(request.getName());
        int battery = validateBattery(request.getBattery());

        return new Drone(
                UUID.randomUUID().toString(),
                name,
                "OFFLINE",
                battery,
                25.0
        );
    }

    // throws InvalidAttributeValueException
    private String validateName(String name) {
        if (name.isEmpty() || name.isBlank()) {
            throw new IllegalArgumentException("Name cannot be empty");
        }
        return name;
    }

    private int validateBattery(int battery) {
        if (battery > 100 || battery < 0) {
            throw new IllegalArgumentException("Battery cannot be less than zero or greater than 100");
        }

        return battery;
    }

}
