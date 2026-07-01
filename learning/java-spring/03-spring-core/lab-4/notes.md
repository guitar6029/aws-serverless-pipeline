# Lab 4 - @Bean and @Configuration

## Goal

Understand how to manually register a Bean without using `@Component`.

---

## Experiment

Created an `EmailClient` class without any Spring annotations.

Created an `AppConfig` class annotated with:

```java
@Configuration
```

Registered `EmailClient` using:

```java
@Bean
public EmailClient emailClient() {
    return new EmailClient("super-secret-api-key");
}
```

Injected `EmailClient` into `DroneController`.

---

## Observation

The application started successfully.

Spring injected `EmailClient` even though the class itself had no Spring annotations.

Calling the endpoint returned:

```
Email Client Connected! API Key = super-secret-api-key
```

---

## Result

`EmailClient` became a managed Bean because it was returned from a method annotated with `@Bean` inside a class annotated with `@Configuration`.

Spring discovered the configuration class during Component Scanning, executed the `@Bean` method during startup, and registered the returned object in the Application Context.

---

## Key Takeaways

- `@Bean` is placed on methods, not classes.
- `@Configuration` tells Spring to inspect the class for Bean definitions.
- A class does not need `@Component` to become a Bean.
- `@Bean` provides explicit control over object creation.