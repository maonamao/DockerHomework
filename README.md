# DockerHomework

项目简介

DockerHomework 是一个围绕 Docker 容器化技术的作业项目，主要包含前端服务的容器化配置与部署。项目通过 Docker 实现前端静态页面的打包、镜像构建及运行，基于 Nginx 服务展示电商相关数据（如商品列表、详情页等），并配置了健康检查机制以确保服务可用性。

docker大作业仓库
项目结构:
project-root/  # 项目根目录
├── docker-compose.yml          # 核心：编排前后端+数据库的总配置
├── .env                        # 全局环境变量（数据库密码、端口、服务名等，避免硬编码）
├── README.md                   #
├── frontend/                   # 前端模块（Vue/React/Angular）
│   ├── Dockerfile              # 前端专属Dockerfile（Node构建+Nginx运行）
│   ├── nginx.conf              # 前端Nginx配置（路由、反向代理后端接口）
│   ├── src/                    # 前端源码
│   ├── public/                 # 前端静态资源
│   ├── package.json            # 前端依赖
│   └── .dockerignore           # 前端专属忽略（node\_modules、.git等）
├── backend/                    # 后端模块（以Java为例，Go/Python同理）
│   ├── Dockerfile              # 后端专属Dockerfile（Maven构建+JRE运行）
│   ├── src/                    # 后端源码
│   ├── pom.xml                 # Maven依赖（Java）/ requirements.txt（Python）
│   ├── application.yml         # 后端配置（可引用.env中的环境变量）
│   └── .dockerignore           # 后端专属忽略（target、node\_modules、.git等）
└── mysql/                      # 数据库模块（MySQL为例，PostgreSQL/Mongo同理）
├── init/                   # 数据库初始化脚本（首次启动自动执行）
│   └── init.sql            # 建库、建表、初始数据SQL
├── conf/                   # 数据库自定义配置
│   └── my.cnf              # MySQL配置（字符集、端口、连接数等）
└── data/                   # 数据库数据持久化目录（关键！避免容器删除数据丢失）

前端服务说明

核心功能

基于 Nginx 构建静态页面容器，提供电商数据展示（商品列表、详情页等）

通过 Dockerfile 自定义镜像，实现前端项目的容器化部署

配置健康检查机制，监控服务运行状态

技术栈

前端框架：基于 Vue（从依赖文件可知使用 Vue 相关工具链）

容器基础镜像：Nginx

构建工具：npm（依赖管理与项目打包）

构建与运行步骤

前提条件

已安装 Docker 环境

已克隆本仓库到本地：

git clone https://github.com/maonamao/DockerHomework.git

cd DockerHomework

前端镜像构建与运行

进入前端项目目录：

cd frontend

构建前端 Docker 镜像（假设镜像名为 frontend-app）：

docker build -t frontend-app .

运行前端容器（映射容器 80 端口到本地 8080 端口）：

docker run -d -p 8080:80 --name frontend-container frontend-app

访问服务：打开浏览器访问 http://localhost:8080 即可查看电商页面

注意事项

前端项目打包需确保依赖安装完整，可在构建前执行 npm install 安装依赖

若需修改 Nginx 配置（如反向代理、静态资源路径等），可在前端项目中添加 nginx.conf 并在 Dockerfile 中复制到容器对应目录

镜像构建时确保 Docker 上下文路径正确，避免不必要的文件被打包进镜像

