package com.joshdev.telemetrydemo.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.joshdev.telemetrydemo.model.Drone;

public interface DroneRepository extends JpaRepository<Drone, String> {

}
