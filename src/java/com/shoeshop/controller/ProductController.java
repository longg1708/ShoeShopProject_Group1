package com.shoeshop.controller;



import com.shoeshop.dao.ProductDAO;
import com.shoeshop.model.Product;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller for the product detail page
 */
@WebServlet(name = "ProductController", urlPatterns = {"/product"})
public class ProductController extends HttpServlet {
    private ProductDAO productDAO;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }
    
    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays product details
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get product ID from request
            String productIdParam = request.getParameter("id");
            
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            try {
                int productId = Integer.parseInt(productIdParam);
                
                // Get product details
                Product product = productDAO.findById(productId);
                
                if (product == null) {
                    request.setAttribute("errorMessage", "Product not found!");
                    request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
                    return;
                }
                
                // Get related products (same category)
                request.setAttribute("product", product);
                request.getRequestDispatcher("/WEB-INF/views/productDetail.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
        }
    }
}
