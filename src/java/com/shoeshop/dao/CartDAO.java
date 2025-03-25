package com.shoeshop.dao;

import com.shoeshop.model.Cart;
import com.shoeshop.model.CartItem;
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
 * Data Access Object for Cart entity
 */
public class CartDAO {
    private final DatabaseConnection dbConnection;
    private final ProductDAO productDAO;
    
    public CartDAO() {
        dbConnection = DatabaseConnection.getInstance();
        productDAO = new ProductDAO();
    }
    
    /**
     * Insert a new cart into the database
     * @param cart Cart to insert
     * @return Inserted cart with generated ID
     * @throws SQLException 
     */
    public Cart insert(Cart cart) throws SQLException {
        String sql = "INSERT INTO Carts (userId) VALUES (?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            conn.setAutoCommit(false);
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, cart.getUserId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating cart failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                cart.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating cart failed, no ID obtained.");
            }
            
            // Insert cart items
            for (CartItem item : cart.getItems()) {
                insertCartItem(conn, cart.getId(), item);
            }
            
            conn.commit();
            return cart;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                dbConnection.closeConnection(conn);
            }
        }
    }
    
    /**
     * Insert a cart item into the database
     * @param conn Database connection
     * @param cartId Cart ID
     * @param item CartItem to insert
     * @throws SQLException 
     */
    private void insertCartItem(Connection conn, int cartId, CartItem item) throws SQLException {
        String sql = "INSERT INTO CartItems (cartId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, cartId);
            stmt.setInt(2, item.getProductId());
            stmt.setInt(3, item.getQuantity());
            stmt.setBigDecimal(4, item.getPrice());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating cart item failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                item.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating cart item failed, no ID obtained.");
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
    }
    
    /**
     * Update an existing cart in the database
     * @param cart Cart to update
     * @return True if update was successful
     * @throws SQLException 
     */
    public boolean update(Cart cart) throws SQLException {
        String sql = "UPDATE Carts SET userId = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbConnection.getConnection();
            conn.setAutoCommit(false);
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, cart.getUserId());
            stmt.setInt(2, cart.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Updating cart failed, no rows affected.");
            }
            
            // Delete existing cart items
            deleteCartItems(conn, cart.getId());
            
            // Insert updated cart items
            for (CartItem item : cart.getItems()) {
                insertCartItem(conn, cart.getId(), item);
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                dbConnection.closeConnection(conn);
            }
        }
    }
    
    /**
     * Delete cart items for a specific cart
     * @param conn Database connection
     * @param cartId Cart ID
     * @throws SQLException 
     */
    private void deleteCartItems(Connection conn, int cartId) throws SQLException {
        String sql = "DELETE FROM CartItems WHERE cartId = ?";
        
        PreparedStatement stmt = null;
        
        try {
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, cartId);
            stmt.executeUpdate();
        } finally {
            if (stmt != null) stmt.close();
        }
    }
    
    /**
     * Delete a cart from the database
     * @param id Cart ID to delete
     * @return True if deletion was successful
     * @throws SQLException 
     */
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM Carts WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Delete cart items first
            deleteCartItems(conn, id);
            
            // Delete cart
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            
            conn.commit();
            return affectedRows > 0;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                dbConnection.closeConnection(conn);
            }
        }
    }
    
    /**
     * Find a cart by user ID
     * @param userId User ID to find cart for
     * @return Cart if found, null otherwise
     * @throws SQLException 
     */
    public Cart findByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM Carts WHERE userId = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Cart cart = new Cart();
                cart.setId(rs.getInt("id"));
                cart.setUserId(rs.getInt("userId"));
                
                // Load cart items
                loadCartItems(cart);
                
                return cart;
            } else {
                // Create a new cart for the user
                Cart newCart = new Cart();
                newCart.setUserId(userId);
                return insert(newCart);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Load cart items for a cart
     * @param cart Cart to load items for
     * @throws SQLException 
     */
    private void loadCartItems(Cart cart) throws SQLException {
        String sql = "SELECT * FROM CartItems WHERE cartId = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, cart.getId());
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setProductId(rs.getInt("productId"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getBigDecimal("price"));
                
                // Load product information
                Product product = productDAO.findById(item.getProductId());
                item.setProduct(product);
                
                cart.getItems().add(item);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Add a product to a user's cart
     * @param userId User ID
     * @param productId Product ID to add
     * @param quantity Quantity to add
     * @return Updated cart
     * @throws SQLException 
     */
    public Cart addToCart(int userId, int productId, int quantity) throws SQLException {
        // Get user's cart
        Cart cart = findByUserId(userId);
        
        // Get product details
        Product product = productDAO.findById(productId);
        if (product == null) {
            throw new SQLException("Product not found with ID: " + productId);
        }
        
        // Check if product already in cart
        boolean productExists = false;
        for (CartItem item : cart.getItems()) {
            if (item.getProductId() == productId) {
                // Update quantity
                item.setQuantity(item.getQuantity() + quantity);
                productExists = true;
                break;
            }
        }
        
        // If product not in cart, add it
        if (!productExists) {
            CartItem newItem = new CartItem();
            newItem.setProductId(productId);
            newItem.setQuantity(quantity);
            newItem.setPrice(product.getPrice());
            newItem.setProduct(product);
            cart.getItems().add(newItem);
        }
        
        // Update cart in database
        update(cart);
        
        return cart;
    }
    
    /**
     * Remove a product from a user's cart
     * @param userId User ID
     * @param productId Product ID to remove
     * @return Updated cart
     * @throws SQLException 
     */
    public Cart removeFromCart(int userId, int productId) throws SQLException {
        // Get user's cart
        Cart cart = findByUserId(userId);
        
        // Remove product from items
        cart.getItems().removeIf(item -> item.getProductId() == productId);
        
        // Update cart in database
        update(cart);
        
        return cart;
    }
    
    /**
     * Update quantity of a product in a user's cart
     * @param userId User ID
     * @param productId Product ID to update
     * @param quantity New quantity
     * @return Updated cart
     * @throws SQLException 
     */
    public Cart updateCartItemQuantity(int userId, int productId, int quantity) throws SQLException {
        // Get user's cart
        Cart cart = findByUserId(userId);
        
        // Find and update product quantity
        for (CartItem item : cart.getItems()) {
            if (item.getProductId() == productId) {
                if (quantity <= 0) {
                    // Remove item if quantity is 0 or negative
                    return removeFromCart(userId, productId);
                } else {
                    item.setQuantity(quantity);
                    // Update cart in database
                    update(cart);
                    return cart;
                }
            }
        }
        
        throw new SQLException("Product not found in cart with ID: " + productId);
    }
    
    /**
     * Clear a user's cart
     * @param userId User ID
     * @return Empty cart
     * @throws SQLException 
     */
    public Cart clearCart(int userId) throws SQLException {
        // Get user's cart
        Cart cart = findByUserId(userId);
        
        // Clear items
        cart.getItems().clear();
        
        // Update cart in database
        update(cart);
        
        return cart;
    }
}
