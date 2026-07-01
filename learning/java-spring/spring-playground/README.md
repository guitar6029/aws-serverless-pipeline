# Lesson 03 - Spring Boot Fundamentals

## Goal

Build the first Spring Boot REST API while understanding what Spring Boot does behind the scenes.

---

# What is Spring Boot?

Spring Boot is a framework built on top of Spring that removes much of the configuration required to build Java applications.

Instead of manually configuring servers, dependency injection, and application startup, Spring Boot provides sensible defaults and auto-configuration.

---

# Spring Initializr

Spring Initializr is similar to tools like:

- Vite
- Angular CLI
- Create React App

It generates a complete project structure.

For this lesson we selected:

- Maven
- Java 21
- Spring Boot
- Spring Web MVC

---

# Maven

Maven is Java's build and dependency management tool.

Responsibilities:

- Download dependencies
- Compile source code
- Run tests
- Package the application
- Run Spring Boot

Common command:

```bash
./mvnw spring-boot:run
```

---

# pom.xml

Similar concepts:

- package.json
- vite.config.ts

Contains:

- Project metadata
- Java version
- Spring dependencies
- Build plugins

Example dependency:

```xml
spring-boot-starter-webmvc
```

This automatically provides:

- Spring MVC
- Embedded Tomcat
- Jackson
- DispatcherServlet

---

# @SpringBootApplication

Marks the application's entry point.

```java
@SpringBootApplication
public class TelemetryDemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(
            TelemetryDemoApplication.class,
            args
        );
    }

}
```

Responsibilities:

- Bootstraps Spring
- Starts component scanning
- Starts auto configuration
- Creates the Application Context

---

# Component Scanning

Spring starts scanning from the package containing:

```java
@SpringBootApplication
```

Example:

```
com.joshdev.telemetrydemo
```

Spring recursively scans subpackages:

```
controller/
service/
repository/
config/
```

and automatically registers classes annotated with:

- @Service
- @RestController
- @Repository
- @Component

Unlike NestJS, there are no explicit Modules required for this example.

---

# Reflection

Spring uses Java Reflection to inspect classes during startup.

It discovers annotations such as:

```java
@Service
@RestController
```

Reflection allows Spring to inspect metadata at runtime.

---

# Application Context

The Application Context is Spring's Dependency Injection container.

It stores managed objects (Beans).

Example:

Application Context

- DroneService
- DroneController
- Future repositories
- Configuration classes

Spring creates these objects and injects dependencies automatically.

---

# Inversion of Control (IoC)

Without Spring:

```java
new DroneService();
```

With Spring:

```java
@Service
public class DroneService {
}
```

Spring creates the object instead of the developer.

Control of object creation is inverted.

---

# Dependency Injection

Controller depends on Service.

```java
private final DroneService droneService;

public DroneController(
        DroneService droneService) {
    this.droneService = droneService;
}
```

Spring automatically provides the DroneService.

No manual instantiation is required.

This is Constructor Injection.

---

# Packages

Every Java file belongs to a package.

Example:

```java
package com.joshdev.telemetrydemo.service;
```

Packages are similar to Go packages/namespaces.

They organize code and allow imports.

---

# Controller

A Controller handles HTTP requests.

Responsibilities:

- Receive HTTP requests
- Validate request parameters
- Delegate work to Services
- Return HTTP responses

Controllers should contain very little business logic.

---

# Service

A Service contains business logic.

Responsibilities:

- Process data
- Validate business rules
- Call repositories
- Return domain objects

Services should not know anything about HTTP.

---

# Model

Models represent domain objects.

Example:

```java
Drone
```

Current properties:

- id
- status
- battery
- temperature

---

# REST Annotations

## @RestController

Marks a class as a REST Controller.

Spring exposes its endpoints.

---

## @RequestMapping

Defines the base URL.

Example:

```java
@RequestMapping("/api/v1/drones")
```

---

## @GetMapping

Handles HTTP GET requests.

Example:

```java
@GetMapping("/{id}")
```

---

Other HTTP annotations:

```java
@PostMapping
@PutMapping
@PatchMapping
@DeleteMapping
```

---

# Endpoint

Current endpoint:

GET

```
/api/v1/drones/{id}
```

Controller:

```java
@GetMapping("/{id}")
public Drone getDrone(
        @PathVariable String id) {

    return droneService.getDrone(id);
}
```

---

# Request Flow

Browser / curl

↓

Tomcat

↓

DispatcherServlet

↓

DroneController

↓

DroneService

↓

Drone

↓

Jackson converts Java Object → JSON

↓

HTTP Response

---

# Running the application

```bash
./mvnw spring-boot:run
```

Test:

```bash
curl http://localhost:8080/api/v1/drones/alpha
```

Response:

```json
{
  "id":"alpha",
  "status":"ONLINE",
  "battery":94,
  "temperature":42.5
}
```

---

# Comparison with NestJS

NestJS

```
@Module
@Controller
@Service
```

Spring

```
@SpringBootApplication
@Component Scan
@RestController
@Service
```

Spring discovers components automatically via package scanning instead of explicit module registration.

---

# Key Takeaways

- Spring Boot is built on Dependency Injection.
- Spring creates and manages objects (Beans).
- Component Scanning automatically discovers annotated classes.
- Controllers handle HTTP.
- Services contain business logic.
- Models represent data.
- Spring Boot includes an embedded Tomcat server.
- Returning a Java object from a REST controller automatically produces JSON.