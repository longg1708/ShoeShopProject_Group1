<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container">
    <h1>Payment via banking app</h1>
    <p>Please scan the QR code below to pay for your order.</p>

    <div class="text-center">
        <img src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=BankApp_Payment_Order_${param.orderId}" 
             alt="QR Code thanh toán" class="img-fluid"/>
    </div>

    <div class="mt-3">
        <a href="${pageContext.request.contextPath}/order-history" class="btn btn-primary">
            Return to orders history
        </a>
    </div>
</div>
