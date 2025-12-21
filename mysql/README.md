# MySQL（Docker）部署与初始化说明
 
 本目录用于在服务器上使用 Docker 启动 MySQL，并在**首次初始化**时自动建库/建表/导入示例数据。
 
 ## 目录结构
 
 - **init/**
   - **schema.sql**：初始化 SQL（容器首次初始化时自动执行）
 - **data/**
   - MySQL 数据持久化目录（挂载到容器 `/var/lib/mysql`）
 
 ## 一、推荐的启动方式（创建业务用户，避免 root@host 权限问题）
 
 你之前遇到的 `Access denied for user 'root'@'xxx'` 是 MySQL 的机制：用户是 `user@host` 的组合，`root` 往往默认只允许 `localhost` 登录。
 
 使用官方 MySQL 镜像时，通过环境变量 `MYSQL_USER/MYSQL_PASSWORD` 创建业务用户（默认就是 `'%'` 远程可用），可以直接规避这个坑。
 
 ### 1) 启动命令（示例）
 
 在服务器项目根目录执行（注意把路径改成你服务器上的实际路径）：
 
 ```bash
 docker run -d \
   --name mysql_docker \
   --restart unless-stopped \
   -p 3306:3306 \
   -e MYSQL_ROOT_PASSWORD=tosennanoda \
   -e MYSQL_DATABASE=docker_last_work \
   -e MYSQL_USER=ecommerce \
   -e MYSQL_PASSWORD=mysql_docker \
   -v $(pwd)/mysql/data:/var/lib/mysql \
   -v $(pwd)/mysql/init:/docker-entrypoint-initdb.d \
   mysql:8.0 \
   --character-set-server=utf8mb4 \
   --collation-server=utf8mb4_unicode_ci
 ```
 
 - **端口**：`-p 3306:3306` 把容器 3306 暴露到宿主机 3306。
 - **数据卷**：`mysql/data` 用于持久化数据。
 - **初始化脚本**：`mysql/init` 会挂载到 `/docker-entrypoint-initdb.d`，**仅在容器第一次初始化（数据目录为空）时执行**。
 - **字符集**：显式设置为 `utf8mb4`，避免中文乱码。
 
 ### 2) 后端连接信息建议
 
 后端建议使用业务用户：
 - `spring.datasource.username=ecommerce`
 - `spring.datasource.password=mysql_docker`
 - `spring.datasource.url=jdbc:mysql://<MySQL宿主机IP>:3306/docker_last_work?...`
 
 如果后端也跑在 Docker 里：
 - 不要用 `localhost` 连接 MySQL（`localhost` 指向容器自己）
 - 用宿主机 IP 或在 `docker compose` 中用 service 名互联
 
 ## 二、初始化脚本说明（schema.sql）
 
 - `init/schema.sql` 已包含：
   - `CREATE DATABASE IF NOT EXISTS docker_last_work ...`
   - `USE docker_last_work;`
   - 建表 + 插入示例数据
 
 注意：脚本里包含 `TRUNCATE TABLE products;`，意味着**初始化时会清空表再导入示例数据**。
 
 ## 三、常见问题与注意事项
 
 - **[初始化脚本不生效]**
   - 只有在 `mysql/data` 为空（首次初始化）时才会执行。
   - 如果你已经启动过并产生了数据，再改 `schema.sql` 不会自动重新执行。
   - 想重新初始化：停止并删除容器，然后清空 `mysql/data`（或换一个新的数据卷目录）再启动。
 
 - **[root 远程登录被拒绝]**
   - 现象：`Access denied for user 'root'@'192.168.56.1'`
   - 处理：优先使用 `MYSQL_USER` 创建的业务用户（推荐）。
 
 - **[中文乱码]**
   - 确保 MySQL 以 `utf8mb4` 启动（本 README 的启动命令已设置）。
   - JDBC URL 中保持 `useUnicode=true&characterEncoding=UTF-8`。
 
 ## 四、快速验证
 
 ```bash
 docker exec -it mysql_docker mysql -uecommerce -pmysql_docker -e "SHOW DATABASES;"
 docker exec -it mysql_docker mysql -uecommerce -pmysql_docker -e "USE docker_last_work; SHOW TABLES; SELECT COUNT(*) FROM products;"
 ```