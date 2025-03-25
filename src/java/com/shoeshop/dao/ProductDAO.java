package com.shoeshop.dao;

import com.shoeshop.model.Product;
import com.shoeshop.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Product entity
 */
public class ProductDAO {
    private final DatabaseConnection dbConnection;
    
    public ProductDAO() {
        dbConnection = DatabaseConnection.getInstance();
    }
    
    /**
     * Insert a new product into the database
     * @param product Product to insert
     * @return Inserted product with generated ID
     * @throws SQLException 
     */
    public Product insert(Product product) throws SQLException {
        String sql = "INSERT INTO Products (name, description, price, stock, imageUrl, categoryId, brandName, size, color) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getImageUrl());
            stmt.setInt(6, product.getCategoryId());
            stmt.setString(7, product.getBrandName());
            stmt.setString(8, product.getSize());
            stmt.setString(9, product.getColor());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating product failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                product.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating product failed, no ID obtained.");
            }
            
            return product;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Update an existing product in the database
     * @param product Product to update
     * @return True if update was successful
     * @throws SQLException 
     */
    public boolean update(Product product) throws SQLException {
        String sql = "UPDATE Products SET name = ?, description = ?, price = ?, "
                + "stock = ?, imageUrl = ?, categoryId = ?, brandName = ?, "
                + "size = ?, color = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStock());
            stmt.setString(5, product.getImageUrl());
            stmt.setInt(6, product.getCategoryId());
            stmt.setString(7, product.getBrandName());
            stmt.setString(8, product.getSize());
            stmt.setString(9, product.getColor());
            stmt.setInt(10, product.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Delete a product from the database
     * @param id Product ID to delete
     * @return True if deletion was successful
     * @throws SQLException 
     */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM Products WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Find a product by ID
     * @param id Product ID to find
     * @return Product if found, null otherwise
     * @throws SQLException 
     */
    public Product findById(int id) throws SQLException {
        String sql = "SELECT * FROM Products WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            } else {
                return null;
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Get all products from the database
     * @return List of all products
     * @throws SQLException 
     */
    public List<Product> findAll() throws SQLException {
        String sql = "SELECT * FROM Products";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
            return products;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Find products by category ID
     * @param categoryId Category ID to filter by
     * @return List of products in the category
     * @throws SQLException 
     */
    public List<Product> findByCategory(int categoryId) throws SQLException {
        String sql = "SELECT * FROM Products WHERE categoryId = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, categoryId);
            
            rs = stmt.executeQuery();
            
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
            return products;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Search products by name or description
     * @param keyword Keyword to search for
     * @return List of products matching the search
     * @throws SQLException 
     */
    public List<Product> search(String keyword) throws SQLException {
        String sql = "SELECT * FROM Products WHERE name LIKE ? OR description LIKE ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            
            rs = stmt.executeQuery();
            
            List<Product> products = new ArrayList<>();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
            
            return products;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Update product stock quantity
     * @param productId Product ID to update
     * @param quantity New stock quantity
     * @return True if update was successful
     * @throws SQLException 
     */
    public boolean updateStock(int productId, int quantity) throws SQLException {
        String sql = "UPDATE Products SET stock = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Map a ResultSet to a Product object
     * @param rs ResultSet containing product data
     * @return Product object
     * @throws SQLException 
     */
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setStock(rs.getInt("stock"));
        product.setImageUrl(rs.getString("imageUrl"));
        product.setCategoryId(rs.getInt("categoryId"));
        product.setBrandName(rs.getString("brandName"));
        product.setSize(rs.getString("size"));
        product.setColor(rs.getString("color"));
        return product;
    }
}
