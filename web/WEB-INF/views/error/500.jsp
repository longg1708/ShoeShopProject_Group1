<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container text-center py-5">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="mb-4">
                <i class="fas fa-cogs fa-5x text-danger"></i>
            </div>
            <h1 class="display-1 fw-bold">500</h1>
            <h2 class="mb-4">Internal Server Error</h2>
            <p class="lead mb-5">
                Oops! Something went wrong. We're working to fix the problem.
                Please try again later.
            </p>
            <div>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg">
                    <i class="fas fa-home me-2"></i>Return to Homepage
                </a>
            </div>
        </div>
    </div>
</div>
