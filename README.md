# DockerHomework
docker大作业仓库
目录结构：
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
│   └── .dockerignore           # 前端专属忽略（node_modules、.git等）
├── backend/                    # 后端模块（以Java为例，Go/Python同理）
│   ├── Dockerfile              # 后端专属Dockerfile（Maven构建+JRE运行）
│   ├── src/                    # 后端源码
│   ├── pom.xml                 # Maven依赖（Java）/ requirements.txt（Python）
│   ├── application.yml         # 后端配置（可引用.env中的环境变量）
│   └── .dockerignore           # 后端专属忽略（target、node_modules、.git等）
└── mysql/                      # 数据库模块（MySQL为例，PostgreSQL/Mongo同理）
    ├── init/                   # 数据库初始化脚本（首次启动自动执行）
    │   └── init.sql            # 建库、建表、初始数据SQL
    ├── conf/                   # 数据库自定义配置
    │   └── my.cnf              # MySQL配置（字符集、端口、连接数等）
    └── data/                   # 数据库数据持久化目录（关键！避免容器删除数据丢失）
