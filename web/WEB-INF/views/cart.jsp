<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container">
    <h1 class="mb-4">Shopping Cart</h1>
    
    <div class="row">
        <div class="col-lg-8">
            <div class="card mb-4">
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty cart && not empty cart.items}">
                            <c:forEach var="item" items="${cart.items}">
                                <div class="cart-item row">
                                    <div class="col-md-2 col-3">
                                        <c:choose>
                                            <c:when test="${not empty item.product.imageUrl}">
                                                <img src="${pageContext.request.contextPath}${item.product.imageUrl}" class="cart-img img-fluid" alt="${item.product.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="bg-secondary d-flex align-items-center justify-content-center" style="width: 80px; height: 80px;">
                                                    <i class="fas fa-shoe-prints fa-2x text-white"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="col-md-4 col-9">
                                        <h5>${item.product.name}</h5>
                                        <p class="text-muted mb-0">
                                            <small>
                                                ${item.product.brandName} 
                                                <c:if test="${not empty item.product.size}">
                                                    | Size: ${item.product.size}
                                                </c:if>
                                                <c:if test="${not empty item.product.color}">
                                                    | Color: ${item.product.color}
                                                </c:if>
                                            </small>
                                        </p>
                                    </div>
                                    
                                    <div class="col-md-2 col-4 mt-3 mt-md-0">
                                        <span class="product-price">$<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></span>
                                    </div>
                                    
                                    <div class="col-md-2 col-4 mt-3 mt-md-0">
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="productId" value="${item.productId}">
                                            <input type="number" class="form-control form-control-sm" name="quantity" value="${item.quantity}" min="1" style="width: 60px;">
                                            <button type="submit" class="btn btn-sm btn-outline-secondary ms-1">
                                                <i class="fas fa-sync-alt"></i>
                                            </button>
                                        </form>
                                    </div>
                                    
                                    <div class="col-md-2 col-4 mt-3 mt-md-0 text-end">
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="productId" value="${item.productId}">
                                            <button type="submit" class="btn btn-sm btn-danger">
                                                <i class="fas fa-trash"></i> Remove
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-shopping-cart fa-4x mb-3 text-muted"></i>
                                <h4>Your cart is empty</h4>
                                <p>Looks like you haven't added any items to your cart yet.</p>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-2">
                                    <i class="fas fa-shoe-prints me-2"></i>Continue Shopping
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <c:if test="${not empty cart && not empty cart.items}">
                    <div class="card-footer">
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Continue Shopping
                            </a>
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="clear">
                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                    <i class="fas fa-trash me-2"></i>Clear Cart
                                </button>
                            </form>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
        
        <div class="col-lg-4">
            <c:if test="${not empty cart && not empty cart.items}">
                <div class="card cart-summary">
                    <div class="card-body">
                        <h5 class="card-title mb-4">Order Summary</h5>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span>Subtotal (${cart.totalItems} items)</span>
                            <span>$<fmt:formatNumber value="${cart.totalPrice}" pattern="#,##0.00"/></span>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span>Shipping</span>
                            <span>Free</span>
                        </div>
                        
                        <hr>
                        
                        <div class="d-flex justify-content-between mb-4">
                            <strong>Total</strong>
                            <strong class="product-price">$<fmt:formatNumber value="${cart.totalPrice}" pattern="#,##0.00"/></strong>
                        </div>
                        
                        <div class="d-grid">
                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success">
                                <i class="fas fa-credit-card me-2"></i>Proceed to Checkout
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>
