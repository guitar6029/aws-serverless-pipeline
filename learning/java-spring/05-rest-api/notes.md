# Module 05 - REST APIs

## Goal

Learn how Spring Boot exposes HTTP endpoints and maps incoming HTTP requests to Java methods.

---

# HTTP Methods

| Method | Purpose |
|---------|----------|
| GET | Retrieve resource(s) |
| POST | Create a resource |
| PUT | Replace an existing resource |
| PATCH | Update part of a resource |
| DELETE | Delete a resource |

---

# Idempotency

An operation is **idempotent** if executing the same request multiple times results in the same final state as executing it once.

Typical HTTP methods:

| Method | Idempotent |
|---------|------------|
| GET | ✅ |
| PUT | ✅ |
| DELETE | ✅ |
| POST | ❌ |
| PATCH | Depends on implementation |

**Key idea**

Idempotency matters because distributed systems retry requests when failures occur.

---

# Request Flow

```
HTTP Request

↓

Tomcat

↓

DispatcherServlet

↓

Controller

↓

Service

↓

Repository (later)

↓

Database

↓

JSON Response
```

---

# Controller Mapping

Controller

```java
@RestController
@RequestMapping("/api/v1/drones")
```

Method

```java
@GetMapping("/{id}")
```

Produces

```
GET /api/v1/drones/{id}
```

---

# @PathVariable

Used to extract values from the URL path.

Example

```
GET /api/v1/drones/42
```

```java
@GetMapping("/{id}")
public Drone getDrone(@PathVariable String id)
```

Spring automatically injects:

```
id = "42"
```

---

# @RequestParam

Used to extract query parameters.

Example

```
GET /api/v1/drones/search?status=ONLINE&page=2
```

```java
@GetMapping("/search")
public String search(
    @RequestParam String status,
    @RequestParam int page
)
```

Spring automatically injects:

```
status = "ONLINE"
page = 2
```

---

# Path Variable vs Request Param

Path Variable

```
/drones/42
```

Identifies the resource.

---

Query Parameters

```
/drones?page=2&status=ONLINE
```

Modify how the resource should be returned (filtering, pagination, sorting, etc.)

---

# DTO (Data Transfer Object)

Purpose:

Transfer data across the application boundary.

A DTO should remain simple and contain only data.

Typical contents:

- Fields
- Constructors
- Getters
- (Later) Validation annotations

Avoid:

- Business logic
- Database access
- HTTP calls
- Complex validation logic

---

# Traditional DTO

```java
public class CreateDroneRequest {

    private String name;
    private int battery;

    public CreateDroneRequest() {}

    public CreateDroneRequest(String name, int battery) {
        this.name = name;
        this.battery = battery;
    }

    public String getName() {
        return name;
    }

    public int getBattery() {
        return battery;
    }
}
```

---

# Modern DTO

```java
public record CreateDroneRequest(
    String name,
    int battery
) {}
```

Records remove boilerplate and are commonly used for DTOs in modern Java.

Traditional POJOs are still extremely common in existing enterprise codebases.

---

# Validation (Current Lesson)

Current approach:

Controller validates incoming request before processing.

Example:

```java
validateName(request.getName());
validateBattery(request.getBattery());
```

Later we'll replace this with Spring Bean Validation:

```java
@NotBlank
@Min(0)
@Max(100)
```

using

```java
@Valid
```

---

# Separation of Responsibilities

Controller

- Receive HTTP request
- Validate request
- Call Service

Service

- Business logic
- Business rules
- Orchestrate repositories

Repository

- Database interaction

DTO

- Data transfer only

Domain Model

- Represents business object

---

# Key Takeaways

- Spring maps HTTP requests to Java methods using annotations.
- `@PathVariable` reads values from the URL path.
- `@RequestParam` reads query parameters.
- DTOs define the API contract.
- Keep DTOs simple.
- Validation belongs at the application boundary.
- Business rules belong in the Service layer.