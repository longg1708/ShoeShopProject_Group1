<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container">
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
            <c:forEach var="category" items="${categories}">
                <c:if test="${category.id eq product.categoryId}">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home?category=${category.id}">${category.name}</a></li>
                </c:if>
            </c:forEach>
            <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
        </ol>
    </nav>
    
    <div class="row">
        <div class="col-md-6 mb-4">
            <div class="card">
                <div class="card-body d-flex justify-content-center align-items-center" style="min-height: 400px;">
                    <c:choose>
                        <c:when test="${not empty product.imageUrl}">
                            <img src="${pageContext.request.contextPath}${product.imageUrl}" class="product-detail-img img-fluid" alt="${product.name}">
                        </c:when>
                        <c:otherwise>
                            <div class="bg-secondary d-flex align-items-center justify-content-center" style="width: 100%; height: 400px;">
                                <i class="fas fa-shoe-prints fa-5x text-white"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <h1 class="mb-2">${product.name}</h1>
            <p class="text-muted mb-3">${product.brandName}</p>
            
            <div class="mb-3">
                <span class="product-price fs-3">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
            </div>
            
            <div class="mb-4">
                <p>${product.description}</p>
            </div>
            
            <div class="row mb-4">
                <div class="col-md-6 mb-3">
                    <h6>Size:</h6>
                    <p>${not empty product.size ? product.size : 'Standard'}</p>
                </div>
                
                <div class="col-md-6 mb-3">
                    <h6>Color:</h6>
                    <p>${not empty product.color ? product.color : 'Standard'}</p>
                </div>
            </div>
            
            <div class="mb-4">
                <h6>Availability:</h6>
                <c:choose>
                    <c:when test="${product.stock gt 0}">
                        <p class="text-success">In Stock (${product.stock} available)</p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-danger">Out of Stock</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <c:if test="${product.stock gt 0}">
                <form action="${pageContext.request.contextPath}/cart" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.id}">
                    
                    <div class="row mb-4 align-items-end">
                        <div class="col-md-4 col-5">
                            <label for="quantity" class="form-label">Quantity</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" value="1" min="1" max="${product.stock}">
                        </div>
                        
                        <div class="col-md-8 col-7">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-cart-plus me-2"></i>Add to Cart
                            </button>
                        </div>
                    </div>
                </form>
            </c:if>
            
            <div class="d-flex">
                <div class="me-4">
                    <i class="fas fa-shipping-fast text-success me-2"></i>Free Shipping
                </div>
                <div>
                    <i class="fas fa-undo text-success me-2"></i>Easy Returns
                </div>
            </div>
        </div>
    </div>
    
    <div class="row mt-5">
        <div class="col-12">
            <h3 class="mb-4">Product Details</h3>
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h5>Features</h5>
                            <ul>
                                <li>Brand: ${product.brandName}</li>
                                <li>Size: ${not empty product.size ? product.size : 'Standard'}</li>
                                <li>Color: ${not empty product.color ? product.color : 'Standard'}</li>
                                <li>High-quality materials</li>
                                <li>Comfortable fit</li>
                                <li>Durable construction</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h5>Description</h5>
                            <p>${not empty product.description ? product.description : 'No detailed description available for this product.'}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
