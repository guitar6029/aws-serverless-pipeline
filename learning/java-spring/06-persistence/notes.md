# Lesson 06 -- Persistence (Spring Data JPA & Hibernate)

## Objectives

- Understand how Spring Boot persists Java objects into a relational
  database.
- Learn the relationship between Spring Data JPA, Hibernate, and
  PostgreSQL.
- Replace in-memory objects with real database persistence.
- Build a complete persistence pipeline using Docker Compose.

---

## Spring Data JPA

- High-level abstraction for relational database access.
- Generates repository implementations automatically.

```java
public interface DroneRepository extends JpaRepository<Drone, UUID> {
}
```

## Hibernate

Responsibilities:

- ORM (Object Relational Mapping)
- Generates SQL
- Persists entities
- Loads entities from the database

Flow:

```text
Entity
  ↓
Hibernate
  ↓
SQL
  ↓
PostgreSQL
```

## Entity Mapping

```java
@Entity
public class Drone {}

@Id
@GeneratedValue
private UUID id;
```

## Enum Persistence

Originally:

```text
OFFLINE -> 0
ONLINE  -> 1
```

Improved with:

```java
@Enumerated(EnumType.STRING)
private DroneStatus status;
```

Now stores:

```text
OFFLINE
ONLINE
```

## Repository Pattern

```text
Controller
  ↓
Service
  ↓
Repository
  ↓
Hibernate
  ↓
PostgreSQL
```

## Optional

```java
Optional<Drone> drone = repository.findById(id);
```

## Docker Compose

Services:

- Spring Boot
- PostgreSQL
- Docker Volume
- Healthcheck

## Environment Variables

```properties
spring.datasource.url=jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
```

Configuration flow:

```text
.env
 ↓
Docker Compose
 ↓
Spring
 ↓
application.properties
```

## Hibernate Schema Generation

```properties
spring.jpa.hibernate.ddl-auto=update
```

Production:

```text
validate + Flyway
```

## Dockerfile Optimization

```dockerfile
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .

RUN ./mvnw dependency:go-offline

COPY src src
```

## ApiResponse

```java
ApiResponse<T>
```

Response:

```json
{
  "data": {},
  "message": "Drone created successfully"
}
```

## End-to-End Flow

```text
HTTP
 ↓
Controller
 ↓
Validation
 ↓
Service
 ↓
Repository
 ↓
Hibernate
 ↓
PostgreSQL
```

## Testing

- Successful POST
- Validation failure
- Verified data with:

```sql
SELECT * FROM drone;
```

## Debugging Lessons

- Incorrect \${} placeholders
- Wrong port (5342 vs 5432)
- Missing JPA no-args constructor
- Final fields incompatible with Hibernate
- Enum migration required recreating schema
- Docker .env vs env_file
- Read the first meaningful startup exception

## Key Takeaways

- Spring Data JPA abstracts CRUD.
- Hibernate maps Java objects to SQL.
- Docker Compose provides reproducible local infrastructure.
- Environment variables are the single source of truth.

# Module 06 Complete

- Spring Boot REST API
- Bean Validation
- Exception Handling
- Spring Data JPA
- Hibernate
- PostgreSQL
- Docker Compose
- Generic API Responses
- End-to-end persistence
