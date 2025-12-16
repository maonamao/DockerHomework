# 第一阶段：构建应用
FROM maven:3.8.6-openjdk-11-slim AS build

WORKDIR /app

# 复制Maven配置文件和项目文件
COPY pom.xml .
COPY src ./src

# 下载依赖（利用Docker缓存层）
RUN mvn dependency:go-offline -B

# 构建应用
RUN mvn clean package -DskipTests

# 第二阶段：运行应用
FROM openjdk:11-jre-slim

WORKDIR /app

# 安装必要的工具
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# 创建非root用户
RUN groupadd -r spring && useradd -r -g spring spring
USER spring:spring

# 从构建阶段复制jar文件
COPY --from=build --chown=spring:spring /app/target/*.jar app.jar

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# 环境变量配置
ENV JAVA_OPTS="-Xmx512m -Xms256m"
ENV SPRING_PROFILES_ACTIVE=production

# 暴露端口
EXPOSE 8080

# 启动应用
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app/app.jar"]
