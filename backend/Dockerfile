FROM maven:3.9.9-eclipse-temurin-21-alpine AS builder

WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests -q

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxRAMPercentage=75 -Dspring.profiles.active=cloud"

COPY --from=builder /build/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
