# Lab 1 - Missing Bean

## Goal

Understand what happens when a required Bean is not registered.

---

## Experiment

Removed:

```java
@Service
```

from `DroneService`.

Started the application:

```bash
mvn spring-boot:run
```

---

## Troubleshooting

Spring failed during startup.

Error:

```
Parameter 0 of constructor in DroneController required a bean of type
'DroneService' that could not be found.
```

Spring suggested registering a Bean of type `DroneService`.

---

## Result

Removing `@Service` prevented `DroneService` from being discovered during
Component Scanning.

Since `DroneController` depends on `DroneService`, Spring could not satisfy
the dependency graph.

The Application Context failed to initialize and the application refused
to start (Fail Fast).

---

## Key Takeaways

- `@Service` registers the class as a Bean.
- A Java class existing is not enough—it must be a managed Bean.
- Spring validates dependencies during startup.
- Missing Beans prevent the application from starting.



## Interview Question

Why did the application fail to start after removing `@Service`?


Spring could not register DroneService as a Bean, so the Application Context could not satisfy the constructor dependency for DroneController. The dependency graph was incomplete, so Spring failed fast during startup.