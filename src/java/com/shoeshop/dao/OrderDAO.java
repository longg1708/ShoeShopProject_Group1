package com.shoeshop.dao;

import com.shoeshop.model.Cart;
import com.shoeshop.model.CartItem;
import com.shoeshop.model.Order;
import com.shoeshop.model.OrderDetail;
import com.shoeshop.model.Product;
import com.shoeshop.util.DatabaseConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Data Access Object for Order entity
 */
public class OrderDAO {
    private final DatabaseConnection dbConnection;
    private final ProductDAO productDAO;
    private final CartDAO cartDAO;
    
    public OrderDAO() {
        dbConnection = DatabaseConnection.getInstance();
        productDAO = new ProductDAO();
        cartDAO = new CartDAO();
    }
    
    /**
     * Insert a new order into the database
     * @param order Order to insert
     * @return Inserted order with generated ID
     * @throws SQLException 
     */
    public Order insert(Order order) throws SQLException {
        String sql = "INSERT INTO Orders (userId, orderDate, totalAmount, shippingAddress, status, paymentMethod) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            conn.setAutoCommit(false);
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, order.getUserId());
            stmt.setTimestamp(2, new Timestamp(order.getOrderDate().getTime()));
            stmt.setBigDecimal(3, order.getTotalAmount());
            stmt.setString(4, order.getShippingAddress());
            stmt.setString(5, order.getStatus());
            stmt.setString(6, order.getPaymentMethod());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                order.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }
            
            // Insert order details
            for (OrderDetail detail : order.getOrderDetails()) {
                detail.setOrderId(order.getId());
                insertOrderDetail(conn, detail);
                
                // Update product stock
                Product product = productDAO.findById(detail.getProductId());
                if (product != null) {
                    int newStock = product.getStock() - detail.getQuantity();
                    if (newStock < 0) {
                        throw new SQLException("Insufficient stock for product ID: " + product.getId());
                    }
                    productDAO.updateStock(product.getId(), newStock);
                }
            }
            
            conn.commit();
            return order;
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
     * Insert an order detail into the database
     * @param conn Database connection
     * @param detail OrderDetail to insert
     * @throws SQLException 
     */
    private void insertOrderDetail(Connection conn, OrderDetail detail) throws SQLException {
        String sql = "INSERT INTO OrderDetails (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
        
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, detail.getOrderId());
            stmt.setInt(2, detail.getProductId());
            stmt.setInt(3, detail.getQuantity());
            stmt.setBigDecimal(4, detail.getPrice());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating order detail failed, no rows affected.");
            }
            
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                detail.setId(rs.getInt(1));
            } else {
                throw new SQLException("Creating order detail failed, no ID obtained.");
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
        }
    }
    
    /**
     * Update an existing order in the database
     * @param order Order to update
     * @return True if update was successful
     * @throws SQLException 
     */
    public boolean update(Order order) throws SQLException {
        String sql = "UPDATE Orders SET status = ? WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, order.getStatus());
            stmt.setInt(2, order.getId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Find an order by ID
     * @param id Order ID to find
     * @return Order if found, null otherwise
     * @throws SQLException 
     */
    public Order findById(int id) throws SQLException {
        String sql = "SELECT * FROM Orders WHERE id = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                
                // Load order details
                loadOrderDetails(order);
                
                return order;
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
     * Find orders by user ID
     * @param userId User ID to find orders for
     * @return List of orders for the user
     * @throws SQLException 
     */
    public List<Order> findByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM Orders WHERE userId = ? ORDER BY orderDate DESC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            rs = stmt.executeQuery();
            
            List<Order> orders = new ArrayList<>();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                
                // Load order details
                loadOrderDetails(order);
                
                orders.add(order);
            }
            
            return orders;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Get all orders from the database
     * @return List of all orders
     * @throws SQLException 
     */
    public List<Order> findAll() throws SQLException {
        String sql = "SELECT * FROM Orders ORDER BY orderDate DESC";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            List<Order> orders = new ArrayList<>();
            while (rs.next()) {
                Order order = mapResultSetToOrder(rs);
                
                // Load order details
                loadOrderDetails(order);
                
                orders.add(order);
            }
            
            return orders;
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Load order details for an order
     * @param order Order to load details for
     * @throws SQLException 
     */
    private void loadOrderDetails(Order order) throws SQLException {
        String sql = "SELECT * FROM OrderDetails WHERE orderId = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = dbConnection.getConnection();
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, order.getId());
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderDetail detail = new OrderDetail();
                detail.setId(rs.getInt("id"));
                detail.setOrderId(rs.getInt("orderId"));
                detail.setProductId(rs.getInt("productId"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setPrice(rs.getBigDecimal("price"));
                
                // Load product information
                Product product = productDAO.findById(detail.getProductId());
                detail.setProduct(product);
                
                order.addOrderDetail(detail);
            }
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) dbConnection.closeConnection(conn);
        }
    }
    
    /**
     * Map a ResultSet to an Order object
     * @param rs ResultSet containing order data
     * @return Order object
     * @throws SQLException 
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("userId"));
        order.setOrderDate(new Date(rs.getTimestamp("orderDate").getTime()));
        order.setTotalAmount(rs.getBigDecimal("totalAmount"));
        order.setShippingAddress(rs.getString("shippingAddress"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("paymentMethod"));
        return order;
    }
    
    /**
     * Create an order from a user's cart
     * @param userId User ID
     * @param shippingAddress Shipping address
     * @param paymentMethod Payment method
     * @return Created order
     * @throws SQLException 
     */
    public Order createOrderFromCart(int userId, String shippingAddress, String paymentMethod) throws SQLException {
        // Get user's cart
        Cart cart = cartDAO.findByUserId(userId);
        
        System.out.println("Cart items count: " + (cart != null ? cart.getItems().size() : "null cart"));
        
        if (cart == null || cart.getItems().isEmpty()) {
        throw new SQLException("Cannot create order: cart is empty");
    }
        
        // Create new order
        Order order = new Order();
        order.setUserId(userId);
        order.setOrderDate(new Date());
        order.setTotalAmount(cart.getTotalPrice());
        order.setShippingAddress(shippingAddress);
        order.setStatus("Pending");
        order.setPaymentMethod(paymentMethod);
        
        // Convert cart items to order details
        for (CartItem item : cart.getItems()) {
            OrderDetail detail = new OrderDetail();
            detail.setProductId(item.getProductId());
            detail.setQuantity(item.getQuantity());
            detail.setPrice(item.getPrice());
            detail.setProduct(item.getProduct());
            order.addOrderDetail(detail);
        }
        
        // Insert order into database
        order = insert(order);
        
        // Clear cart after successful order
        cartDAO.clearCart(userId);
        
        return order;
    }
}
