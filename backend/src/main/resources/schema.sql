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
('iPhone 14', '苹果最新款手机', 6999.00, 100, '手机数码', 'https://store.storeimages.cdn-apple.com/8756/as-images.apple.com/is/iphone-14-pro-model-unselect-gallery-2-202209?wid=5120&hei=2880&fmt=p-jpg&qlt=80&.v=1660753617553', NOW(), NOW()),
('小米电视 4K', '55英寸4K超高清智能电视', 2999.00, 50, '家用电器', 'https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/0a89c9e76d61ad33a3ab99065e828715.jpg', NOW(), NOW()),
('华为笔记本电脑', 'MateBook 14 2023款', 5999.00, 30, '电脑办公', 'https://consumer-img.huawei.com/content/dam/huawei-cbg-site/common/mkt/pdp/pc/matebook-14-2022/img/pc-section1-banner.jpg', NOW(), NOW()),
('耐克运动鞋', 'Air Max 270 气垫跑鞋', 899.00, 200, '运动户外', 'https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/awjogtdnqxniot40d4ne/air-max-270-mens-shoes-KkLcGR.png', NOW(), NOW());