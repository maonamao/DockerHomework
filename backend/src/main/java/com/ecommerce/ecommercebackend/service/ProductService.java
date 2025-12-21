package com.ecommerce.ecommercebackend.service;

import com.ecommerce.ecommercebackend.dto.ProductDTO;
import com.ecommerce.ecommercebackend.entity.Product;
import java.util.List;

public interface ProductService {
    List<Product> getAllProducts();
    Product getProductById(Long id);
    Product createProduct(ProductDTO productDTO);
    Product updateProduct(Long id, ProductDTO productDTO);
    void deleteProduct(Long id);
}