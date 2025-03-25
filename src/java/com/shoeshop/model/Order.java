package com.shoeshop.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Order model class representing a customer order
 */
public class Order implements Serializable {
    private int id;
    private int userId;
    private Date orderDate;
    private BigDecimal totalAmount;
    private String shippingAddress;
    private String status;
    private String paymentMethod;
    private List<OrderDetail> orderDetails;
    
    public Order() {
        orderDetails = new ArrayList<>();
    }
    
    public Order(int id, int userId, Date orderDate, BigDecimal totalAmount, String shippingAddress, String status, String paymentMethod) {
        this.id = id;
        this.userId = userId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.status = status;
        this.paymentMethod = paymentMethod;
        this.orderDetails = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }
    
    public void addOrderDetail(OrderDetail detail) {
        orderDetails.add(detail);
    }

    @Override
    public String toString() {
        return "Order{" + "id=" + id + ", userId=" + userId + ", orderDate=" + orderDate + ", totalAmount=" + totalAmount + ", status=" + status + "}";
    }
}
