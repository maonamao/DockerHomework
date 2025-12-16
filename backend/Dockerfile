# 使用完整的JDK版本，避免slim版本的问题
FROM maven:3.8.6-jdk-11 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

# 构建应用
RUN mvn clean package -DskipTests

# 运行阶段 - 使用完整的jre而不是slim
FROM openjdk:11-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
