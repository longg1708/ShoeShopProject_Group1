<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- Hero Banner -->
<div class="hero-banner position-relative" style="width: 100%; height: 500px; overflow: hidden;">
    <video autoplay loop muted playsinline class="hero-video" style="width: 100%; height: 100%; object-fit: cover;">
        <source src="${pageContext.request.contextPath}/images/banner.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <div class="hero-overlay position-absolute top-0 start-0 w-100 h-100" style="background: rgba(0, 0, 0, 0.5);"></div>
    <div class="container text-white position-absolute top-50 start-50 translate-middle text-center" style="z-index: 2;">
        <h1 class="display-3 fw-bold text-uppercase" style="text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.7);">Unleash Your Step in Style</h1>   
        <p class="lead">Find the perfect shoes that fit your journey.</p>
        <a href="#featured-products" id="shopNowBtn" class="btn btn-light btn-lg fw-bold px-4 py-2 shadow" style="border-radius: 50px; transition: all 0.3s;">
            Shop Now
        </a>
    </div>
</div>

<!-- Categories -->
<div class="container my-5">
    <h2 class="text-center mb-4 fw-bold">Shop by Category</h2>
    <div class="row row-cols-2 row-cols-md-4 g-4">
        <c:forEach var="category" items="${categories}">
            <div class="col">
                <a href="${pageContext.request.contextPath}/home?category=${category.id}" class="text-decoration-none">
                    <div class="card h-100 border-0 shadow ${selectedCategory.id eq category.id ? 'border-primary' : ''}">
                        <div class="card-body text-center">
                            <c:choose>
                                <c:when test="${category.name eq 'Running'}">
                                    <img src="${pageContext.request.contextPath}/images/running.jpg" alt="Running" class="img-fluid mb-3" style="max-height: 80px;">
                                </c:when>
                                <c:when test="${category.name eq 'Casual'}">
                                    <img src="${pageContext.request.contextPath}/images/casual.jpg" alt="Casual" class="img-fluid mb-3" style="max-height: 80px;">
                                </c:when>
                                <c:when test="${category.name eq 'Sports'}">
                                    <img src="${pageContext.request.contextPath}/images/sports.jpg" alt="Sports" class="img-fluid mb-3" style="max-height: 80px;">
                                </c:when>
                                <c:when test="${category.name eq 'Formal'}">
                                    <img src="${pageContext.request.contextPath}/images/formal.jpg" alt="Formal" class="img-fluid mb-3" style="max-height: 80px;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/images/default.jpg" alt="Default" class="img-fluid mb-3" style="max-height: 80px;">
                                </c:otherwise>
                            </c:choose>
                            <h5 class="card-title fw-bold">${category.name}</h5>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Featured Products -->
<div id="featured-products" class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">
            <c:choose>
                <c:when test="${not empty selectedCategory}">
                    ${selectedCategory.name}
                </c:when>
                <c:otherwise>
                    Featured Products
                </c:otherwise>
            </c:choose>
        </h2>
        <c:if test="${not empty selectedCategory}">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">
                <i class="fas fa-times me-1"></i> Clear Filter
            </a>
        </c:if>
    </div>

    <div class="row row-cols-1 row-cols-md-3 g-4">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="product" items="${products}">
                    <div class="col">
                        <div class="card h-100 shadow border-0">
                            <div class="p-3 text-center">
                                <c:choose>
                                    <c:when test="${not empty product.imageUrl}">
                                        <img src="${pageContext.request.contextPath}${product.imageUrl}" class="card-img-top"
                                             alt="${product.name}"
                                             style="width: 100%; height: 150px; object-fit: contain; border-radius: 8px;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-secondary d-flex align-items-center justify-content-center"
                                             style="height: 150px; border-radius: 8px;">
                                            <i class="fas fa-shoe-prints fa-3x text-white"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body text-center">
                                <h5 class="card-title fw-bold">${product.name}</h5>
                                <p class="text-muted">${product.brandName}</p>
                                <p class="fw-bold text-primary">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></p>
                                <a href="${pageContext.request.contextPath}/product?id=${product.id}" class="btn btn-outline-primary">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col text-center">
                    <div class="alert alert-info">No products found.</div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<!-- Features -->
<div class="container mb-5">
    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card h-100 text-center">
                <div class="card-body">
                    <i class="fas fa-shipping-fast fa-3x mb-3 text-primary"></i>
                    <h5 class="card-title">Fast Shipping</h5>
                    <p class="card-text">Free shipping on orders over $50. Get your shoes delivered in 2-5 business days.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 text-center">
                <div class="card-body">
                    <i class="fas fa-undo fa-3x mb-3 text-primary"></i>
                    <h5 class="card-title">Easy Returns</h5>
                    <p class="card-text">Not satisfied? Return within 30 days for a full refund or exchange.</p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-4">
            <div class="card h-100 text-center">
                <div class="card-body">
                    <i class="fas fa-headset fa-3x mb-3 text-primary"></i>
                    <h5 class="card-title">Customer Support</h5>
                    <p class="card-text">Our team is available 24/7 to help you with any questions or concerns.</p>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- JavaScript -->
<script>
    // Hiệu ứng hover cho nút Shop Now
    document.querySelector("shopNowBtn").addEventListener("mouseover", function () {
        this.style.backgroundColor = "black";
        this.style.color = "white";
    });

    document.querySelector("shopNowBtn").addEventListener("mouseleave", function () {
        this.style.backgroundColor = "white";
        this.style.color = "black";
    });
</script>