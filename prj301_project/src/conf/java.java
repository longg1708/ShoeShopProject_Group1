
package com.shoeshop.controller;

import com.shoeshop.dao.CategoryDAO;
import com.shoeshop.dao.OrderDAO;
import com.shoeshop.dao.ProductDAO;
import com.shoeshop.dao.UserDAO;
import com.shoeshop.model.Category;
import com.shoeshop.model.Order;
import com.shoeshop.model.Product;
import com.shoeshop.model.User;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for admin functionality
 */
@WebServlet(name = "AdminController", urlPatterns = {
    "/admin", 
    "/admin/products", 
    "/admin/product/edit", 
    "/admin/product/delete",
    "/admin/orders",
    "/admin/order/update"
})
public class AdminController extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private OrderDAO orderDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();
    }
    
    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays admin pages
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            if ("/admin".equals(path)) {
                // Admin dashboard
                request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
            } else if ("/admin/products".equals(path)) {
                // Product management
                List<Product> products = productDAO.findAll();
                List<Category> categories = categoryDAO.findAll();
                
                request.setAttribute("products", products);
                request.setAttribute("categories", categories);
                request.getRequestDispatcher("/WEB-INF/admin/products.jsp").forward(request, response);
            } else if ("/admin/product/edit".equals(path)) {
                // Edit product form
                String productIdParam = request.getParameter("id");
                List<Category> categories = categoryDAO.findAll();
                request.setAttribute("categories", categories);
                
                if (productIdParam != null && !productIdParam.isEmpty()) {
                    // Edit existing product
                    int productId = Integer.parseInt(productIdParam);
                    Product product = productDAO.findById(productId);
                    
                    if (product == null) {
                        response.sendRedirect(request.getContextPath() + "/admin/products");
                        return;
                    }
                    
                    request.setAttribute("product", product);
                }
                
                request.getRequestDispatcher("/WEB-INF/admin/editProduct.jsp").forward(request, response);
            } else if ("/admin/orders".equals(path)) {
                // Order management
                List<Order> orders = orderDAO.findAll();
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
    
    /**
     * Handles the HTTP <code>POST</code> method.
     * Processes admin actions
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            if ("/admin/product/edit".equals(path)) {
                // Save product
                String productIdParam = request.getParameter("id");
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                String priceParam = request.getParameter("price");
                String stockParam = request.getParameter("stock");
                String imageUrl = request.getParameter("imageUrl");
                String categoryIdParam = request.getParameter("categoryId");
                String brandName = request.getParameter("brandName");
                String size = request.getParameter("size");
                String color = request.getParameter("color");
                
                // Validate input
                if (name == null || name.isEmpty() || 
                    priceParam == null || priceParam.isEmpty() ||
                    stockParam == null || stockParam.isEmpty() ||
                    categoryIdParam == null || categoryIdParam.isEmpty()) {
                    
                    request.setAttribute("errorMessage", "Required fields cannot be empty!");
                    doGet(request, response);
                    return;
                }
                
                // Parse numeric values
                BigDecimal price = new BigDecimal(priceParam);
                int stock = Integer.parseInt(stockParam);
                int categoryId = Integer.parseInt(categoryIdParam);
                
                Product product;
                
                if (productIdParam != null && !productIdParam.isEmpty()) {
                    // Update existing product
                    int productId = Integer.parseInt(productIdParam);
                    product = productDAO.findById(productId);
                    
                    if (product == null) {
                        response.sendRedirect(request.getContextPath() + "/admin/products");
                        return;
                    }
                } else {
                    // Create new product
                    product = new Product();
                }
                
                // Set product properties
                product.setName(name);
                product.setDescription(description);
                product.setPrice(price);
                product.setStock(stock);
                product.setImageUrl(imageUrl);
                product.setCategoryId(categoryId);
                product.setBrandName(brandName);
                product.setSize(size);
                product.setColor(color);
                
                if (product.getId() > 0) {
                    // Update existing product
                    productDAO.update(product);
                } else {
                    // Insert new product
                    productDAO.insert(product);
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else if ("/admin/product/delete".equals(path)) {
                // Delete product
                String productIdParam = request.getParameter("id");
                
                if (productIdParam != null && !productIdParam.isEmpty()) {
                    int productId = Integer.parseInt(productIdParam);
                    productDAO.delete(productId);
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/products");
            } else if ("/admin/order/update".equals(path)) {
                // Update order status
                String orderIdParam = request.getParameter("orderId");
                String status = request.getParameter("status");
                
                if (orderIdParam != null && !orderIdParam.isEmpty() && 
                    status != null && !status.isEmpty()) {
                    
                    int orderId = Integer.parseInt(orderIdParam);
                    Order order = orderDAO.findById(orderId);
                    
                    if (order != null) {
                        order.setStatus(status);
                        orderDAO.update(order);
                    }
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            doGet(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format!");
            doGet(request, response);
        }
    }
}
