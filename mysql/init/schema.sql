-- 创建并使用数据库（容器首次初始化时执行）
CREATE DATABASE IF NOT EXISTS docker_last_work CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE docker_last_work;

SET NAMES utf8mb4;

-- 创建products表（如果不存在）
CREATE TABLE IF NOT EXISTS products (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    price DECIMAL(19,2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(100),
    image_url VARCHAR(500),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 清空旧数据（防止乱码数据）
TRUNCATE TABLE products;

-- 插入示例数据（使用UTF-8编码）
INSERT INTO products (name, description, price, stock, category, image_url, created_at, updated_at) VALUES
('iPhone 14', '苹果最新款手机', 6999.00, 100, '手机数码', 'https://picsum.photos/seed/iphone14/600/400', NOW(), NOW()),
('小米电视 4K', '55英寸4K超高清智能电视', 2999.00, 50, '家用电器', 'https://picsum.photos/seed/xiaomi-tv/600/400', NOW(), NOW()),
('华为笔记本电脑', 'MateBook 14 2023款', 5999.00, 30, '电脑办公', 'https://picsum.photos/seed/huawei-laptop/600/400', NOW(), NOW()),
('耐克运动鞋', 'Air Max 270 气垫跑鞋', 899.00, 200, '运动户外', 'https://picsum.photos/seed/nike-shoes/600/400', NOW(), NOW());
