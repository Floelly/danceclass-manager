FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /build
COPY . .
RUN apk add --no-cache maven && \
    mvn clean package -DskipTests -q

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Kostenoptimierung: Minimal Java runtime
ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxRAMPercentage=75 -Dspring.profiles.active=cloud"

COPY --from=builder /build/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
