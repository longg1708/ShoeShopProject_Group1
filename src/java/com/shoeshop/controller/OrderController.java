package com.shoeshop.controller;

import com.shoeshop.dao.CartDAO;
import com.shoeshop.dao.OrderDAO;
import com.shoeshop.model.Cart;
import com.shoeshop.model.Order;
import com.shoeshop.model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for orders
 */
@WebServlet(name = "OrderController", urlPatterns = {"/checkout", "/orders", "/order-history"})
public class OrderController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method. Displays checkout, order
     * details, or order history
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession();
    User user = (User) session.getAttribute("user");

    // 1️⃣ Kiểm tra session hợp lệ
    if (user == null) {
        System.out.println("Session expired, redirecting to login...");
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String path = request.getServletPath();
    System.out.println("Processing GET request: " + path + " for user ID: " + user.getId());

    try {
        if ("/checkout".equals(path)) {
            System.out.println("Loading checkout page...");
            try {
                Cart cart = new CartDAO().findByUserId(user.getId());

                if (cart == null || cart.getItems().isEmpty()) {
                    System.out.println("Cart is empty, redirecting to home...");
                    session.setAttribute("errorMessage", "Your cart is empty. Please add items before checkout.");
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }

                request.setAttribute("cart", cart);
                request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Database error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/home");
            }

        } else if ("/orders".equals(path)) {
            System.out.println("Loading order details...");
            String orderIdParam = request.getParameter("id");

            if (orderIdParam != null && !orderIdParam.isEmpty()) {
                try {
                    int orderId = Integer.parseInt(orderIdParam);
                    Order order = orderDAO.findById(orderId);

                    if (order == null) {
                        System.out.println("Order not found: " + orderId);
                        response.sendRedirect(request.getContextPath() + "/order-history");
                        return;
                    }

                    if (order.getUserId() != user.getId() && !user.isAdmin()) {
                        System.out.println("User unauthorized to view order: " + orderId);
                        response.sendRedirect(request.getContextPath() + "/order-history");
                        return;
                    }

                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/WEB-INF/views/orderDetail.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid order ID: " + orderIdParam);
                    response.sendRedirect(request.getContextPath() + "/order-history");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/order-history");
            }

        } else if ("/order-history".equals(path)) {
            System.out.println("Loading order history...");
            List<Order> orders;

            if (user.isAdmin()) {
                orders = orderDAO.findAll();
            } else {
                orders = orderDAO.findByUserId(user.getId());
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/views/ordersHistory.jsp").forward(request, response);
        } else {
            System.out.println("Invalid path: " + path);
            response.sendRedirect(request.getContextPath() + "/home");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/home");
    }
}


    /**
     * Handles the HTTP <code>POST</code> method. Processes order creation
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1️⃣ Kiểm tra session có hợp lệ không
        if (user == null) {
            System.out.println("Session expired, redirecting to login...");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 2️⃣ Lấy thông tin từ form
            String shippingAddress = request.getParameter("shippingAddress");
            String paymentMethod = request.getParameter("paymentMethod");

            System.out.println("Received order request - User: " + user.getId() + ", Payment: " + paymentMethod);

            // 3️⃣ Kiểm tra dữ liệu nhập vào
            if (shippingAddress == null || shippingAddress.isEmpty()
                    || paymentMethod == null || paymentMethod.isEmpty()) {
                request.setAttribute("errorMessage", "Please fill in enough information!");
                request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
                return;
            }

            // 4️⃣ Xử lý tạo đơn hàng
            Order order = orderDAO.createOrderFromCart(user.getId(), shippingAddress, paymentMethod);

            if (order == null) {
                System.out.println("Failed to create order for user: " + user.getId());
                request.setAttribute("errorMessage", "Order creation failed. Please try again!");
                request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
                return;
            }

            System.out.println("Order created successfully! Order ID: " + order.getId());

            // 5️⃣ Lưu thông báo thành công vào session để hiển thị sau khi redirect
            session.setAttribute("successMessage", "Order successfully placed! Order ID: " + order.getId());

            // 6️⃣ Chuyển hướng tùy theo phương thức thanh toán
            if ("COD".equalsIgnoreCase(paymentMethod)) {
                response.sendRedirect(request.getContextPath() + "/order-history");
            } else if ("BankApp".equalsIgnoreCase(paymentMethod)) {
                response.sendRedirect(request.getContextPath() + "/qr-payment?orderId=" + order.getId());
            } else {
                System.out.println("Unknown payment method: " + paymentMethod);
                request.setAttribute("errorMessage", "Invalid payment method!");
                request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQL Error: " + e.getMessage());
            request.setAttribute("errorMessage", "Error when ordering: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
        }
    }

}
