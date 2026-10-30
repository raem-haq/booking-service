  FROM eclipse-temurin:21-jdk AS build
  WORKDIR /src
  COPY gradlew settings.gradle.kts build.gradle.kts ./
  COPY gradle gradle
  RUN ./gradlew --no-daemon dependencies > /dev/null 2>&1 || true
  COPY src src
  RUN ./gradlew bootJar --no-daemon -x test

FROM eclipse-temurin:21-jre
  WORKDIR /app
  RUN useradd --system --no-create-home appuser
  COPY --from=build /src/build/libs/*.jar app.jar
  USER appuser
  EXPOSE 8080
  ENTRYPOINT ["java", "-jar", "app.jar"]