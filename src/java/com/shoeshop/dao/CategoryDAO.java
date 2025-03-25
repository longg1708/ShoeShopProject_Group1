package com.shoeshop.dao;

import com.shoeshop.model.Category;
import com.shoeshop.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Category entity
 */
public class CategoryDAO {
    private final DatabaseConnection dbConnection;
    
    public CategoryDAO() {
        dbConnection = DatabaseConnection.getInstance();
    }
    
    /**
     * Insert a new category into the database
     * @param category Category to insert
     * @return Inserted category with generated ID
     * @throws SQLException 
     */
    public Category insert(Category category) throws SQLException {
        String sql = "INSERT INTO Categories (name, description) VALUES (?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating category failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                category.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating category failed, no ID obtained.");
            }
            
            return category;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Update an existing category in the database
     * @param category Category to update
     * @return True if update was successful
     * @throws SQLException 
     */
    public boolean update(Category category) throws SQLException {
        String sql = "UPDATE Categories SET name = ?, description = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Delete a category from the database
     * @param id Category ID to delete
     * @return True if deletion was successful
     * @throws SQLException 
     */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM Categories WHERE id = ?";
        
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
     * Find a category by ID
     * @param id Category ID to find
     * @return Category if found, null otherwise
     * @throws SQLException 
     */
    public Category findById(int id) throws SQLException {
        String sql = "SELECT * FROM Categories WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCategory(rs);
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
     * Get all categories from the database
     * @return List of all categories
     * @throws SQLException 
     */
    public List<Category> findAll() throws SQLException {
        String sql = "SELECT * FROM Categories";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            List<Category> categories = new ArrayList<>();
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
            
            return categories;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Map a ResultSet to a Category object
     * @param rs ResultSet containing category data
     * @return Category object
     * @throws SQLException 
     */
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        return category;
    }
}
