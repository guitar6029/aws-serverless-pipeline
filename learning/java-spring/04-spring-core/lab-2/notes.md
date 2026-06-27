# Lab 2 - Singleton Scope

## Goal

Verify that Spring creates one shared instance of a Bean by default.

---

## Experiment

Injected `DroneService` into:

- DroneController
- TelemetryService

Printed:

```java
System.identityHashCode(droneService)
```

from both locations.

---

## Observation

Both references produced the same identity hash code.

The value remained the same across multiple HTTP requests while the application was running.

After restarting the application, a new identity hash code was generated.

---

## Result

Spring created a single `DroneService` Bean during application startup.

Both `DroneController` and `TelemetryService` received references to the same object.

Restarting the application destroys the old Bean and creates a new Singleton instance.

---

## Key Takeaways

- Beans are Singletons by default.
- Dependency Injection shares the same Bean instance.
- Beans are created during application startup.
- A new Singleton is created only after restarting the application.