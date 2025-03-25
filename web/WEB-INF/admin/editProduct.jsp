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
                <div class="mb-4">
                    <h1>${empty product ? 'Add New Product' : 'Edit Product'}</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/products">Products</a></li>
                            <li class="breadcrumb-item active" aria-current="page">${empty product ? 'Add New Product' : 'Edit Product'}</li>
                        </ol>
                    </nav>
                </div>
                
                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/product/edit" method="post">
                            <c:if test="${not empty product}">
                                <input type="hidden" name="id" value="${product.id}">
                            </c:if>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Product Name*</label>
                                    <input type="text" class="form-control" id="name" name="name" value="${product.name}" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="categoryId" class="form-label">Category*</label>
                                    <select class="form-select" id="categoryId" name="categoryId" required>
                                        <option value="">Select a category</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.id}" ${product.categoryId eq category.id ? 'selected' : ''}>
                                                ${category.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label">Price ($)*</label>
                                    <input type="number" class="form-control" id="price" name="price" min="0.01" step="0.01" value="<fmt:formatNumber value="${empty product.price ? 0 : product.price}" pattern="#0.00" />" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="stock" class="form-label">Stock Quantity*</label>
                                    <input type="number" class="form-control" id="stock" name="stock" min="0" value="${empty product.stock ? 0 : product.stock}" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3">${product.description}</textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="brandName" class="form-label">Brand</label>
                                    <input type="text" class="form-control" id="brandName" name="brandName" value="${product.brandName}">
                                </div>
                                
                                <div class="col-md-3 mb-3">
                                    <label for="size" class="form-label">Size</label>
                                    <input type="text" class="form-control" id="size" name="size" value="${product.size}">
                                </div>
                                
                                <div class="col-md-3 mb-3">
                                    <label for="color" class="form-label">Color</label>
                                    <input type="text" class="form-control" id="color" name="color" value="${product.color}">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label">Image URL</label>
                                <input type="url" class="form-control" id="imageUrl" name="imageUrl" value="${pageContext.request.contextPath}${product.imageUrl}">
                                <div class="form-text">Enter a valid URL for the product image.</div>
                            </div>
                            
                            <div class="mt-4">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Save Product
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary ms-2">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
