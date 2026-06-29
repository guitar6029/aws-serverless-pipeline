# Spring Core - Notes

## Lesson Goals

Understand how Spring manages objects, dependencies, and application startup.

Instead of memorizing annotations, understand **how Spring thinks**.

---

# Core Mental Model

Spring is an **IoC (Inversion of Control) container**.

Instead of the developer manually creating objects, Spring creates and manages them.

Without Spring:

```java
DroneRepository repository = new DroneRepository();

DroneService service = new DroneService(repository);

DroneController controller = new DroneController(service);
```

With Spring:

The developer simply declares what each class requires.

Spring builds the object graph automatically.

---

# Bean

A **Bean** is simply:

> An object whose lifecycle is managed by Spring.

Examples:

* Services
* Controllers
* Repositories
* Configuration objects
* Custom objects registered with `@Bean`

A Java class is **not** automatically a Bean.

---

# Application Context

The Application Context is Spring's container.

Responsibilities:

* Stores all Beans
* Resolves dependencies
* Creates objects
* Injects dependencies
* Manages lifecycle
* Destroys Beans during shutdown

Think of it as Spring's "registry" of managed objects.

---

# Dependency Injection (DI)

Classes declare what they need.

Example:

```java
public class DroneController {

    private final DroneService droneService;

    public DroneController(DroneService droneService) {
        this.droneService = droneService;
    }

}
```

The controller never creates:

```java
new DroneService();
```

Spring provides the dependency automatically.

---

# Dependency Graph

Spring builds an object graph.

Example:

```
DroneController
        │
needs   ▼
DroneService
        │
needs   ▼
DroneRepository
```

Spring ensures every dependency can be satisfied before the application starts.

---

# Fail Fast Principle

If Spring cannot satisfy the dependency graph:

Application startup fails.

Example:

Removing:

```java
@Service
```

from `DroneService`

causes:

```
DroneController

↓

Missing DroneService Bean

↓

Application fails to start
```

Spring refuses to start instead of injecting null references.

---

# Bean Lifecycle (High Level)

```
Application OFF

↓

SpringApplication.run()

↓

Application Context starts

↓

Component Scan

↓

Discover Components

↓

Register Bean Definitions

↓

Resolve Dependencies

↓

Create Bean Instances

↓

Inject Dependencies

↓

Application Ready

↓

Application Running

↓

Application Shutdown

↓

Destroy Beans
```

---

# Component Scanning

Spring scans packages starting from the main application class.

It looks for classes annotated with:

* @Component
* @Service
* @Repository
* @Controller
* @RestController
* @Configuration

Those classes become candidates for Bean creation.

---

# @Component

The generic Spring annotation.

Meaning:

> "Spring, manage this class."

Spring:

* Creates the object
* Registers it as a Bean
* Manages its lifecycle

---

# Specialized Components

These all behave like Components while communicating intent.

```
@Component
        │
        ├── @Service
        │      Business Logic
        │
        ├── @Repository
        │      Data Access
        │
        ├── @Controller
        │      MVC Controller
        │
        └── @RestController
               REST API Controller
```

They improve readability and clearly define responsibilities.

---

# Singleton (Default Scope)

By default Spring creates **one shared instance** of each Bean.

Example:

```
DroneController

↓

DroneService

↓

Same DroneService instance
```

Unless configured otherwise, every injection receives the same object.

---

# @Bean

Unlike `@Component`, `@Bean` is placed on **methods**.

Example:

```java
@Configuration
public class AppConfig {

    @Bean
    public EmailClient emailClient() {
        return new EmailClient(...);
    }

}
```

Purpose:

Allows the developer to explicitly control how an object is created.

Useful for:

* Third-party libraries
* Complex constructors
* Custom initialization
* External SDKs

---

# @Configuration

Marks a class that contains Bean definitions.

Without:

```java
@Configuration
```

Spring ignores methods annotated with:

```java
@Bean
```

Spring first discovers the configuration class, then processes its Bean methods.

---

# @Component vs @Bean

## @Component

Placed on classes.

Spring creates the object.

```
@Service

↓

Spring

↓

new DroneService()
```

---

## @Bean

Placed on methods.

Developer creates the object.

```
@Bean

↓

return new EmailClient(...)

↓

Spring manages returned object
```

---

# Flexibility

Spring provides multiple ways to register Beans.

Automatic:

```
@Component

↓

Spring creates object
```

Explicit:

```
@Bean

↓

Developer creates object
```

Different approaches.

Same result:

A managed Bean inside the Application Context.

---

# Spring's Responsibilities

Spring handles:

* Component scanning
* Bean registration
* Object creation
* Dependency resolution
* Dependency injection
* Lifecycle management
* Bean destruction

Spring does NOT handle:

* Business logic
* Validation rules
* Algorithms
* SQL queries
* Domain models

Those remain the developer's responsibility.

---

# Key Takeaways

* A Java class is not automatically a Bean.
* A Bean is an object managed by Spring.
* The Application Context stores and manages Beans.
* Dependency Injection removes manual object creation.
* Spring validates the dependency graph during startup.
* Missing dependencies cause startup failure (Fail Fast).
* `@Component` marks classes for automatic Bean creation.
* `@Service`, `@Repository`, and `@RestController` are specialized Components.
* Beans are Singletons by default.
* `@Bean` provides explicit control over object creation.
* `@Configuration` groups Bean definitions.
* Spring emphasizes convention by default while allowing explicit configuration when needed.

---

# Mental Model

```
Developer

↓

Writes business logic

↓

Declares dependencies

↓

Spring

↓

Finds Components

↓

Creates Beans

↓

Builds Dependency Graph

↓

Injects Dependencies

↓

Manages Lifecycle

↓

Application Ready
```
