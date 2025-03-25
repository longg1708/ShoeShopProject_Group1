<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container">
    <div class="mb-4">
        <h1>Order Details</h1>
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/order-history">My Orders</a></li>
                <li class="breadcrumb-item active" aria-current="page">Order #${order.id}</li>
            </ol>
        </nav>
    </div>
    
    <div class="row">
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Order #${order.id}</h5>
                        <span class="badge 
                            <c:choose>
                                <c:when test="${order.status eq 'Pending'}">bg-warning text-dark</c:when>
                                <c:when test="${order.status eq 'Processing'}">bg-info</c:when>
                                <c:when test="${order.status eq 'Shipped'}">bg-primary</c:when>
                                <c:when test="${order.status eq 'Delivered'}">bg-success</c:when>
                                <c:when test="${order.status eq 'Cancelled'}">bg-danger</c:when>
                                <c:otherwise>bg-secondary</c:otherwise>
                            </c:choose>
                        ">
                            ${order.status}
                        </span>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead class="table-light">
                                <tr>
                                    <th>Product</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th class="text-end">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${order.orderDetails}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <c:choose>
                                                    <c:when test="${not empty item.product.imageUrl}">
                                                        <img src="${pageContext.request.contextPath}${item.product.imageUrl}" alt="${item.product.name}" style="width: 50px; height: 50px; object-fit: contain;" class="me-3">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="bg-secondary text-white d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px;">
                                                            <i class="fas fa-shoe-prints"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/product?id=${item.productId}" class="text-decoration-none">
                                                        ${item.product.name}
                                                    </a>
                                                    <small class="text-muted d-block">
                                                        <c:if test="${not empty item.product.size}">Size: ${item.product.size}</c:if>
                                                        <c:if test="${not empty item.product.color}">| Color: ${item.product.color}</c:if>
                                                    </small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                        <td>${item.quantity}</td>
                                        <td class="text-end">$<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3" class="text-end"><strong>Total</strong></td>
                                    <td class="text-end"><strong>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></strong></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Order Information</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <h6>Order Date</h6>
                        <p><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm" /></p>
                    </div>
                    
                    <div class="mb-3">
                        <h6>Payment Method</h6>
                        <p>${order.paymentMethod}</p>
                    </div>
                    
                    <div class="mb-3">
                        <h6>Shipping Address</h6>
                        <p>${order.shippingAddress}</p>
                    </div>
                    
                    <c:if test="${order.status eq 'Shipped'}">
                        <div class="mb-3">
                            <h6>Tracking Information</h6>
                            <p class="text-muted">Your order has been shipped. <br>Tracking number: TRACK12345678</p>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Need Help?</h5>
                </div>
                <div class="card-body">
                    <p>If you have any questions about your order, please contact our customer support team.</p>
                    <div class="d-flex align-items-center mb-2">
                        <i class="fas fa-envelope me-2 text-primary"></i>
                        <span>support@shoeshop.com</span>
                    </div>
                    <div class="d-flex align-items-center">
                        <i class="fas fa-phone me-2 text-primary"></i>
                        <span>(123) 456-7890</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="mt-4 mb-5 text-center">
        <a href="${pageContext.request.contextPath}/order-history" class="btn btn-primary me-2">
            <i class="fas fa-arrow-left me-2"></i>Back to Orders
        </a>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
            <i class="fas fa-home me-2"></i>Continue Shopping
        </a>
    </div>
</div>
