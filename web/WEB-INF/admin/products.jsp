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
                        <a href="${pageContext.request.contextPath}/admin/products" class="nav-link active">
                            <i class="fas fa-shoe-prints me-2"></i>Products
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="nav-link text-white">
                            <i class="fas fa-shopping-bag me-2"></i>Orders
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main content -->
        <div class="col-md-9 col-lg-10">
            <div class="container py-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>Products Management</h1>
                    <a href="${pageContext.request.contextPath}/admin/product/edit" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Add New Product
                    </a>
                </div>
                
                <!-- Products Table -->
                <div class="card">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Image</th>
                                        <th>Name</th>
                                        <th>Category</th>
                                        <th>Price</th>
                                        <th>Stock</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty products}">
                                            <c:forEach var="product" items="${products}">
                                                <tr>
                                                    <td>${product.id}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty product.imageUrl}">
                                                                <img src="${pageContext.request.contextPath}${product.imageUrl}" alt="${product.name}" style="width: 50px; height: 50px; object-fit: contain;">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="bg-secondary text-white d-flex align-items-center justify-content-center" style="width: 50px; height: 50px;">
                                                                    <i class="fas fa-shoe-prints"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${product.name}</td>
                                                    <td>
                                                        <c:forEach var="category" items="${categories}">
                                                            <c:if test="${category.id eq product.categoryId}">
                                                                ${category.name}
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td>$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${product.stock lt 5}">
                                                                <span class="badge bg-danger">${product.stock}</span>
                                                            </c:when>
                                                            <c:when test="${product.stock lt 10}">
                                                                <span class="badge bg-warning text-dark">${product.stock}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-success">${product.stock}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" class="btn btn-sm btn-primary">
                                                                <i class="fas fa-edit"></i> Edit
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal${product.id}">
                                                                <i class="fas fa-trash"></i> Delete
                                                            </button>
                                                        </div>
                                                        
                                                        <!-- Delete Confirmation Modal -->
                                                        <div class="modal fade" id="deleteModal${product.id}" tabindex="-1" aria-labelledby="deleteModalLabel${product.id}" aria-hidden="true">
                                                            <div class="modal-dialog">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title" id="deleteModalLabel${product.id}">Confirm Delete</h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        Are you sure you want to delete the product "${product.name}"?
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                        <form action="${pageContext.request.contextPath}/admin/product/delete" method="post">
                                                                            <input type="hidden" name="id" value="${product.id}">
                                                                            <button type="submit" class="btn btn-danger">Delete</button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7" class="text-center">No products found.</td>
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
