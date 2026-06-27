# Lab 3 - Circular Dependency

## Goal

Understand why Spring rejects circular Bean dependencies.

---

## Experiment

Created two services:

AService → depends on BService

BService → depends on AService

Started the application.

---

## Observation

Spring failed during startup.

Error:

"The dependencies of some of the beans in the application context form a cycle."

Spring also displayed a dependency graph showing:

AService ↔ BService

---

## Result

Although both Beans were discovered, Spring could not determine a valid creation order.

Neither Bean could be constructed first because each required the other.

The Application Context failed to initialize.

---

## Key Takeaways

- Spring validates the dependency graph during startup.
- Constructor injection exposes circular dependencies immediately.
- Circular Bean dependencies are prohibited by default.
- Most circular dependencies indicate a design problem.