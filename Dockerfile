FROM maven:3-eclipse-temurin-8 as builder

WORKDIR /app

# download artifacts
COPY pom.xml .
COPY assembly.xml .
RUN mvn dependency:resolve
RUN mvn verify
RUN mvn compiler:help

# build
COPY src ./src
RUN mvn clean package -DskipTests
RUN mv target/ysoserial-*all*.jar target/ysoserial.jar

FROM eclipse-temurin:8-jdk

WORKDIR /app

COPY --from=builder /app/target/ysoserial.jar .

ENTRYPOINT ["java", "-jar", "ysoserial.jar"]
