package com.shoeshop.controller;

import com.shoeshop.dao.CategoryDAO;
import com.shoeshop.dao.ProductDAO;
import com.shoeshop.model.Category;
import com.shoeshop.model.Product;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller for the home page
 */
@WebServlet(name = "HomeController", urlPatterns = {"", "/home"})
public class HomeController extends HttpServlet {
    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }
    
    /**
     * Handles the HTTP <code>GET</code> method.
     * Displays the home page with products
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all categories
            List<Category> categories = categoryDAO.findAll();
            request.setAttribute("categories", categories);
            
            // Get category filter if exists
            String categoryParam = request.getParameter("category");
            List<Product> products;
            
            if (categoryParam != null && !categoryParam.isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryParam);
                    products = productDAO.findByCategory(categoryId);
                    
                    // Set selected category
                    for (Category category : categories) {
                        if (category.getId() == categoryId) {
                            request.setAttribute("selectedCategory", category);
                            break;
                        }
                    }
                } catch (NumberFormatException e) {
                    products = productDAO.findAll();
                }
            } else {
                // Get all products
                products = productDAO.findAll();
            }
            
            request.setAttribute("products", products);
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
        }
    }
}
