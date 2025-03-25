<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3 col-lg-2 admin-sidebar">
            <div class="d-flex flex-column flex-shrink-0 p-3 text-white">
                <span class="fs-4 mb-3">Admin Dashboard</span>
                <hr>
                <ul class="nav nav-pills flex-column mb-auto">
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/admin" class="nav-link active">
                            <i class="fas fa-home me-2"></i>Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/products" class="nav-link text-white">
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
                <h1 class="mb-4">Dashboard</h1>
                
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <div class="card bg-primary text-white">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="card-title">Products</h5>
                                        <h2 class="mb-0" id="productCount">Loading...</h2>
                                    </div>
                                    <i class="fas fa-shoe-prints fa-3x"></i>
                                </div>
                                <a href="${pageContext.request.contextPath}/admin/products" class="text-white">Manage products <i class="fas fa-arrow-right"></i></a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <div class="card bg-success text-white">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="card-title">Orders</h5>
                                        <h2 class="mb-0" id="orderCount">Loading...</h2>
                                    </div>
                                    <i class="fas fa-shopping-bag fa-3x"></i>
                                </div>
                                <a href="${pageContext.request.contextPath}/admin/orders" class="text-white">Manage orders <i class="fas fa-arrow-right"></i></a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4 mb-4">
                        <div class="card bg-warning text-dark">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="card-title">Users</h5>
                                        <h2 class="mb-0" id="userCount">Loading...</h2>
                                    </div>
                                    <i class="fas fa-users fa-3x"></i>
                                </div>
                                <span class="text-dark">Registered users</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-4">
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-dark text-white">
                                <h5 class="mb-0">Recent Orders</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Date</th>
                                                <th>Status</th>
                                                <th>Amount</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody id="recentOrdersTable">
                                            <tr>
                                                <td colspan="5" class="text-center">Loading...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer">
                                <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-sm btn-dark">View All Orders</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-dark text-white">
                                <h5 class="mb-0">Low Stock Products</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Product</th>
                                                <th>Stock</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody id="lowStockTable">
                                            <tr>
                                                <td colspan="3" class="text-center">Loading...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="card-footer">
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-sm btn-dark">Manage Inventory</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Fetch dashboard data when page loads
    document.addEventListener('DOMContentLoaded', function() {
        // Simulate loading dashboard data
        // In a real implementation, you would fetch this data from the server
        
        // Update product count
        setTimeout(() => {
            document.getElementById('productCount').textContent = "45";
        }, 500);
        
        // Update order count
        setTimeout(() => {
            document.getElementById('orderCount').textContent = "28";
        }, 700);
        
        // Update user count
        setTimeout(() => {
            document.getElementById('userCount').textContent = "125";
        }, 900);
        
        // Update recent orders table
        setTimeout(() => {
            const recentOrdersHtml = `
                <tr>
                    <td>1023</td>
                    <td>2023-06-15</td>
                    <td><span class="badge bg-success">Delivered</span></td>
                    <td>$249.99</td>
                    <td><a href="${pageContext.request.contextPath}/orders?id=1023" class="btn btn-sm btn-primary">View</a></td>
                </tr>
                <tr>
                    <td>1022</td>
                    <td>2023-06-14</td>
                    <td><span class="badge bg-warning text-dark">Shipped</span></td>
                    <td>$189.95</td>
                    <td><a href="${pageContext.request.contextPath}/orders?id=1022" class="btn btn-sm btn-primary">View</a></td>
                </tr>
                <tr>
                    <td>1021</td>
                    <td>2023-06-13</td>
                    <td><span class="badge bg-info">Processing</span></td>
                    <td>$329.50</td>
                    <td><a href="${pageContext.request.contextPath}/orders?id=1021" class="btn btn-sm btn-primary">View</a></td>
                </tr>
            `;
            document.getElementById('recentOrdersTable').innerHTML = recentOrdersHtml;
        }, 1000);
        
        // Update low stock table
        setTimeout(() => {
            const lowStockHtml = `
                <tr>
                    <td>Nike Air Max 270</td>
                    <td><span class="badge bg-danger">2</span></td>
                    <td><a href="${pageContext.request.contextPath}/admin/product/edit?id=12" class="btn btn-sm btn-warning">Update</a></td>
                </tr>
                <tr>
                    <td>Adidas Ultraboost</td>
                    <td><span class="badge bg-warning text-dark">5</span></td>
                    <td><a href="${pageContext.request.contextPath}/admin/product/edit?id=8" class="btn btn-sm btn-warning">Update</a></td>
                </tr>
                <tr>
                    <td>Puma RS-X</td>
                    <td><span class="badge bg-warning text-dark">4</span></td>
                    <td><a href="${pageContext.request.contextPath}/admin/product/edit?id=15" class="btn btn-sm btn-warning">Update</a></td>
                </tr>
            `;
            document.getElementById('lowStockTable').innerHTML = lowStockHtml;
        }, 1200);
    });
</script>
