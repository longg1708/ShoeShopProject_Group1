<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3 col-lg-2 admin-sidebar">
            <div class="d-flex flex-column flex-shrink-0 p-3 text-white">
                <span class="fs-4 mb-3">Admin Dashboard</span>
                <hr>
                <ul class="nav nav-pills flex-column mb-auto">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin" class="nav-link text-white">
                            <i class="fas fa-home me-2"></i>Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/products" class="nav-link text-white">
                            <i class="fas fa-shoe-prints me-2"></i>Products
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link active">
                            <i class="fas fa-shopping-bag me-2"></i>Orders
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main content -->
        <div class="col-md-9 col-lg-10">
            <div class="container py-4">
                <h1 class="mb-4">Orders Management</h1>
                
                <!-- Orders Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Date</th>
                                        <th>Customer</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Payment Method</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty orders}">
                                            <c:forEach var="order" items="${orders}">
                                                <tr>
                                                    <td>${order.id}</td>
                                                    <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                                                    <td>User ID: ${order.userId}</td>
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
                                                    <td>${order.paymentMethod}</td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="${pageContext.request.contextPath}/orders?id=${order.id}" class="btn btn-sm btn-primary">
                                                                <i class="fas fa-eye"></i> View
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#updateStatusModal${order.id}">
                                                                <i class="fas fa-edit"></i> Update Status
                                                            </button>
                                                        </div>
                                                        
                                                        <!-- Update Status Modal -->
                                                        <div class="modal fade" id="updateStatusModal${order.id}" tabindex="-1" aria-labelledby="updateStatusModalLabel${order.id}" aria-hidden="true">
                                                            <div class="modal-dialog">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title" id="updateStatusModalLabel${order.id}">Update Order Status</h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                    </div>
                                                                    <form action="${pageContext.request.contextPath}/admin/order/update" method="post">
                                                                        <div class="modal-body">
                                                                            <input type="hidden" name="orderId" value="${order.id}">
                                                                            
                                                                            <div class="mb-3">
                                                                                <label for="orderStatus${order.id}" class="form-label">Status</label>
                                                                                <select class="form-select" id="orderStatus${order.id}" name="status" required>
                                                                                    <option value="Pending" ${order.status eq 'Pending' ? 'selected' : ''}>Pending</option>
                                                                                    <option value="Processing" ${order.status eq 'Processing' ? 'selected' : ''}>Processing</option>
                                                                                    <option value="Shipped" ${order.status eq 'Shipped' ? 'selected' : ''}>Shipped</option>
                                                                                    <option value="Delivered" ${order.status eq 'Delivered' ? 'selected' : ''}>Delivered</option>
                                                                                    <option value="Cancelled" ${order.status eq 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="modal-footer">
                                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                            <button type="submit" class="btn btn-primary">Update Status</button>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center">No orders found.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
