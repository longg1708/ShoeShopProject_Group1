package com.shoeshop.model;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * CartItem model class representing an item in the shopping cart
 */
public class CartItem implements Serializable {
    private int id;
    private int productId;
    private int quantity;
    private BigDecimal price;
    private Product product;
    
    public CartItem() {
    }
    
    public CartItem(int id, int productId, int quantity, BigDecimal price) {
        this.id = id;
        this.productId = productId;
        this.quantity = quantity;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
    
    public BigDecimal getSubtotal() {
        return price.multiply(new BigDecimal(quantity));
    }

    @Override
    public String toString() {
        return "CartItem{" + "id=" + id + ", productId=" + productId + ", quantity=" + quantity + ", price=" + price + "}";
    }
}
