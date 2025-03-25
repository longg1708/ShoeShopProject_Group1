<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container">
    <h1 class="mb-4">Checkout</h1>

    <c:choose>
        <c:when test="${not empty cart && not empty cart.items}">
            <div class="row">
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Shipping Information</h5>
                        </div>
                        <div class="card-body">
                            <form id="checkoutForm">
                                <div class="mb-3">
                                    <label for="shippingAddress" class="form-label">Shipping Address*</label>
                                    <textarea class="form-control" id="shippingAddress" name="shippingAddress" rows="3" required>${sessionScope.user.address}</textarea>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Payment Method</label>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="COD" checked>
                                        <label class="form-check-label" for="cod">
                                            <i class="fas fa-money-bill-wave me-2"></i> Cash on Delivery
                                        </label>
                                    </div>
                                </div>

                                <div class="d-grid mt-4">
                                    <button type="submit" class="btn btn-success btn-lg">
                                        <i class="fas fa-check-circle me-2"></i> Place Order
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Success message (Hidden initially) -->
                    <div id="successMessage" class="alert alert-success text-center d-none">
                        <h4>🎉 Order Placed Successfully!</h4>
                        <p>Thank you for your purchase. Your order will be delivered soon.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Return to Home</a>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card cart-summary mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Order Summary</h5>
                        </div>
                        <div class="card-body">
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

                            <div class="card bg-light mb-3">
                                <div class="card-body py-2">
                                    <h6 class="mb-3">Items in Your Order</h6>
                                    <c:forEach var="item" items="${cart.items}">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <span>${item.product.name}</span>
                                                <small class="text-muted d-block">Qty: ${item.quantity}</small>
                                            </div>
                                            <span>$<fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <i class="fas fa-shield-alt fa-2x text-success me-3"></i>
                                <div>
                                    <h6 class="mb-0">Secure Checkout</h6>
                                    <small class="text-muted">Your payment information is secure</small>
                                </div>
                            </div>

                            <div class="d-flex align-items-center">
                                <i class="fas fa-truck fa-2x text-primary me-3"></i>
                                <div>
                                    <h6 class="mb-0">Free Shipping</h6>
                                    <small class="text-muted">On all orders</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning" role="alert">
                Your cart is empty. You cannot proceed to checkout.
                <a href="${pageContext.request.contextPath}/home" class="alert-link">Click here</a> to continue shopping.
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Listen for form submission
        const checkoutForm = document.getElementById('checkoutForm');
        const successMessage = document.getElementById('successMessage');

        checkoutForm.addEventListener('submit', function (event) {
            event.preventDefault(); // Prevent form from submitting to server

            // Validate shipping address
            const shippingAddress = document.getElementById('shippingAddress').value.trim();
            if (!shippingAddress) {
                alert('Please enter your shipping address.');
                return;
            }

            // Show success message
            checkoutForm.style.display = 'none';  // Hide form
            successMessage.classList.remove('d-none'); // Show success message

            // Optionally, clear cart from session (if needed)
            <% session.removeAttribute("cart"); %>
        });
    });
</script>
