# 构建阶段
FROM node:18-alpine AS build-stage

WORKDIR /app

# 复制依赖文件
COPY package*.json ./

# 安装依赖 - 使用npm install而不是npm ci
RUN npm install --no-save

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 运行阶段 - 使用Nginx
FROM nginx:alpine AS production-stage

# 复制构建好的文件
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 简单的nginx配置
COPY nginx.conf /etc/nginx/nginx.conf

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
