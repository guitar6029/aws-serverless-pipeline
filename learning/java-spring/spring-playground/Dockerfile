FROM maven:3.9-eclipse-temurin-21

WORKDIR /src

COPY . .

RUN chmod +x mvnw

CMD ["./mvnw", "spring-boot:run"]