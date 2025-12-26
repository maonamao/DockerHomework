package com.ecommerce.ecommercebackend.dto;

import lombok.Data;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;

@Data
public class ProductDTO {
    private Long id;

    @NotBlank(message = "Product name is required")
    private String name;

    private String description;

    @NotNull(message = "Price is required")
    private BigDecimal price;

    private Integer stock;

    private String category;

    private String imageUrl;

    private java.util.Date createdAt;
    private java.util.Date updatedAt;
}