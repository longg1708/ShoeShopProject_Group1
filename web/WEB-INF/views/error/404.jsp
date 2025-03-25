<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container text-center py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="mb-4">
                <i class="fas fa-exclamation-triangle fa-5x text-warning"></i>
            </div>
            <h1 class="display-1 fw-bold">404</h1>
            <h2 class="mb-4">Page Not Found</h2>
            <p class="lead mb-5">
                Sorry, the page you are looking for does not exist or has been moved.
            </p>
            <div>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg">
                    <i class="fas fa-home me-2"></i>Return to Homepage
                </a>
            </div>
        </div>
    </div>
</div>
