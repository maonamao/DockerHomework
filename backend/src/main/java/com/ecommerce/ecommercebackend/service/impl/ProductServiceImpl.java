package com.ecommerce.ecommercebackend.service.impl;

import com.ecommerce.ecommercebackend.dto.ProductDTO;
import com.ecommerce.ecommercebackend.entity.Product;
import com.ecommerce.ecommercebackend.repository.ProductRepository;
import com.ecommerce.ecommercebackend.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
    }

    @Override
    public Product createProduct(ProductDTO productDTO) {
        Product product = new Product();
        BeanUtils.copyProperties(productDTO, product);
        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Long id, ProductDTO productDTO) {
        Product existingProduct = getProductById(id);
        BeanUtils.copyProperties(productDTO, existingProduct, "id");
        return productRepository.save(existingProduct);
    }

    @Override
    public void deleteProduct(Long id) {
        Product product = getProductById(id);
        productRepository.delete(product);
    }
}