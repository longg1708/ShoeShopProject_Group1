<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container">
    <div class="mb-4">
        <h1>Search Results</h1>
        <p>Showing results for: <strong>${keyword}</strong></p>
    </div>
    
    <div class="row">
        <c:choose>
            <c:when test="${not empty products && products.size() > 0}">
                <c:forEach var="product" items="${products}">
                    <div class="col-md-4 col-sm-6 mb-4">
                        <div class="card product-card h-100">
                            <div class="product-img-container p-3">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl}">
                                        <img src="${pageContext.request.contextPath}${product.imageUrl}" class="card-img-top" alt="${product.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-secondary d-flex align-items-center justify-content-center" style="height: 180px;">
                                            <i class="fas fa-shoe-prints fa-4x text-white"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">${product.name}</h5>
                                <p class="card-text text-muted">${product.brandName}</p>
                                <div class="d-flex justify-content-between align-items-center mt-auto">
                                    <span class="product-price">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                                    <a href="${pageContext.request.contextPath}/product?id=${product.id}" class="btn btn-sm btn-outline-primary">View Details</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="alert alert-info" role="alert">
                        <i class="fas fa-info-circle me-2"></i> No products found matching your search criteria.
                    </div>
                    <div class="text-center mb-4">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                            <i class="fas fa-home me-2"></i>Back to Home
                        </a>
                    </div>
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Search Tips</h5>
                            <ul>
                                <li>Check spelling of keywords</li>
                                <li>Try more general keywords</li>
                                <li>Try different keywords</li>
                                <li>Browse our categories for inspiration</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <c:if test="${not empty products && products.size() > 0}">
        <div class="mt-4 mb-5 text-center">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
                <i class="fas fa-home me-2"></i>Continue Shopping
            </a>
        </div>
    </c:if>
</div>
