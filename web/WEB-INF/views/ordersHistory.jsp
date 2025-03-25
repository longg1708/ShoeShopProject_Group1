<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container">
    <div class="mb-4">
        <h1>My Orders</h1>
        <p>View and track your order history</p>
    </div>
    
    <div class="card mb-5">
        <div class="card-body">
            <c:choose>
                
                <c:when test="${not empty orders && orders.size() > 0}">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>Order ID</th>
                                    <th>Date</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>${order.id}</td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                        <td>$<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                        <td>
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
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/orders?id=${order.id}" class="btn btn-sm btn-primary">
                                                <i class="fas fa-eye me-1"></i> View Details
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="fas fa-box-open fa-4x mb-3 text-muted"></i>
                        <h4>No Orders Yet</h4>
                        <p>You haven't placed any orders yet.</p>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary mt-2">
                            <i class="fas fa-shopping-bag me-2"></i>Start Shopping
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div class="card mb-4">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Order Status Guide</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex align-items-center">
                            <span class="badge bg-warning text-dark me-3">Pending</span>
                            <span>Your order has been placed but not yet processed</span>
                        </li>
                        <li class="list-group-item d-flex align-items-center">
                            <span class="badge bg-info me-3">Processing</span>
                            <span>Your order is being processed and prepared for shipping</span>
                        </li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex align-items-center">
                            <span class="badge bg-primary me-3">Shipped</span>
                            <span>Your order has been shipped and is on its way to you</span>
                        </li>
                        <li class="list-group-item d-flex align-items-center">
                            <span class="badge bg-success me-3">Delivered</span>
                            <span>Your order has been delivered successfully</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
