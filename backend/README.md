需要在dockerfile写打包项目并构建镜像运行，放在项目根目录

后端API服务（10分）
● 基于Java Web（Spring Boot）的RESTful API容器
● 提供完整的CRUD接口（商品数据的增删改查）
● 使用多阶段构建优化镜像大小
● 配置合理的环境变量管理
数据库服务（10分）
● MySQL容器化部署
● 数据持久化配置（volume或bind mount）
● 初始化脚本自动化执行
● 数据库连接配置优化