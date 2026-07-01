package com.joshdev.telemetrydemo.controller;

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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

import jakarta.validation.Valid;

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
    public Drone getDrone(@PathVariable UUID id) {
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
    public ResponseEntity<Drone> createDrone(
            @Valid @RequestBody CreateDroneRequest request
    ) {

        Drone drone = droneService.createDrone(request);

        return ResponseEntity.status(HttpStatus.CREATED).body(drone);
    }

}
