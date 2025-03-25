package com.shoeshop.controller;

import com.shoeshop.dao.CartDAO;
import com.shoeshop.model.Cart;
import com.shoeshop.model.User;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for the shopping cart
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {
    private CartDAO cartDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
    }
    
    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays the cart page
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get user's cart  
            Cart cart = cartDAO.findByUserId(user.getId());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles the HTTP <code>POST</code> method.
     * Handles cart actions (add, remove, update)
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            String productIdParam = request.getParameter("productId");
            int productId = Integer.parseInt(productIdParam);
            
            if ("add".equals(action)) {
                String quantityParam = request.getParameter("quantity");
                int quantity = 1; // Default quantity
                
                if (quantityParam != null && !quantityParam.isEmpty()) {
                    quantity = Integer.parseInt(quantityParam);
                }
                
                cartDAO.addToCart(user.getId(), productId, quantity);
                response.sendRedirect(request.getContextPath() + "/cart");
            } else if ("remove".equals(action)) {
                cartDAO.removeFromCart(user.getId(), productId);
                response.sendRedirect(request.getContextPath() + "/cart");
            } else if ("update".equals(action)) {
                String quantityParam = request.getParameter("quantity");
                int quantity = 1; // Default quantity
                
                if (quantityParam != null && !quantityParam.isEmpty()) {
                    quantity = Integer.parseInt(quantityParam);
                }
                
                cartDAO.updateCartItemQuantity(user.getId(), productId, quantity);
                response.sendRedirect(request.getContextPath() + "/cart");
            } else if ("clear".equals(action)) {
                cartDAO.clearCart(user.getId());
                response.sendRedirect(request.getContextPath() + "/cart");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
