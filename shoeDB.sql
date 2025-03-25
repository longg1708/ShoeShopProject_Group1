-- Create database
CREATE DATABASE ShoesDB;
GO

USE ShoesDB;
GO

-- Create Users table
CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    fullName NVARCHAR(100) NOT NULL,
    address NVARCHAR(255),
    phone NVARCHAR(20),
    isAdmin BIT NOT NULL DEFAULT 0
);
GO

-- Create Categories table
CREATE TABLE Categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    description NVARCHAR(255)
);
GO

-- Create Products table
CREATE TABLE Products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    imageUrl NVARCHAR(255),
    categoryId INT NOT NULL,
    brandName NVARCHAR(50),
    size NVARCHAR(20),
    color NVARCHAR(30),
    FOREIGN KEY (categoryId) REFERENCES Categories(id)
);
GO

-- Create Carts table
CREATE TABLE Carts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES Users(id)
);
GO

-- Create CartItems table
CREATE TABLE CartItems (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cartId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (cartId) REFERENCES Carts(id) ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES Products(id)
);
GO

-- Create Orders table
CREATE TABLE Orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    orderDate DATETIME NOT NULL DEFAULT GETDATE(),
    totalAmount DECIMAL(10, 2) NOT NULL,
    shippingAddress NVARCHAR(255) NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    paymentMethod NVARCHAR(50) NOT NULL,
    FOREIGN KEY (userId) REFERENCES Users(id)
);
GO

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    id INT IDENTITY(1,1) PRIMARY KEY,
    orderId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (orderId) REFERENCES Orders(id) ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES Products(id)
);
GO

-- Insert initial admin user
INSERT INTO Users (username, password, email, fullName, isAdmin)
VALUES ('admin', 'admin123', 'admin@shoeshop.com', 'Administrator', 1);
GO

-- Insert sample categories
INSERT INTO Categories (name, description)
VALUES 
('Running', 'Shoes designed for running and jogging'),
('Casual', 'Everyday casual shoes for a relaxed style'),
('Sports', 'Athletic shoes for various sports activities'),
('Formal', 'Elegant shoes for formal occasions');
GO

-- Insert sample products
INSERT INTO Products (name, description, price, stock, imageUrl, categoryId, brandName, size, color)
VALUES 
('Nike Air Zoom Pegasus', 'The Nike Air Zoom Pegasus features responsive cushioning and a breathable mesh upper.', 119.99, 15, '/images/NikeAirZoomPegasus.jpg', 1, 'Nike', '42', 'Blue'),
('Adidas Ultraboost', 'Responsive running shoes with energy return technology.', 179.99, 10, '/images/AdidasUltraboost.jpg', 1, 'Adidas', '41', 'Black'),
('Vans Old Skool', 'Classic casual skate shoes with the iconic side stripe.', 69.99, 20, '/images/VansOldSkool.jpg', 2, 'Vans', '43', 'Black/White'),
('Converse Chuck Taylor', 'Timeless high-top sneakers for everyday wear.', 59.99, 25, '/images/ConverseChuckTaylor.jpg', 2, 'Converse', '42', 'Red'),
('Under Armour HOVR', 'Basketball shoes with excellent ankle support and responsive cushioning.', 129.99, 8, '/images/UnderArmourHOVR.jpg', 3, 'Under Armour', '44', 'Red/Black'),
('New Balance 990', 'Performance running shoes with superior comfort and support.', 149.99, 12, '/images/NewBalance990.jpg', 1, 'New Balance', '42', 'Grey'),
('Oxford Leather Wingtip', 'Elegant leather oxfords with classic wingtip design.', 159.99, 7, '/images/OxfordLeatherWingtip.jpg', 4, 'Cole Haan', '43', 'Brown'),
('Penny Loafers', 'Classic slip-on leather loafers for formal occasions.', 129.99, 9, '/images/PennyLoafers.jpg', 4, 'Johnston & Murphy', '42', 'Black'),
('Puma Velocity Nitro', 'Lightweight running shoes with responsive Nitro foam technology.', 139.99, 11, '/images/PumaVelocityNitro.jpg', 3, 'Puma', '41', 'Green');
GO

-- Create stored procedures

-- Get all products with stock less than a specified amount
CREATE PROCEDURE GetLowStockProducts
    @threshold INT = 10
AS
BEGIN
    SELECT * FROM Products WHERE stock <= @threshold ORDER BY stock ASC;
END
GO

-- Get products by category
CREATE PROCEDURE GetProductsByCategory
    @categoryId INT
AS
BEGIN
    SELECT * FROM Products WHERE categoryId = @categoryId;
END
GO

-- Search products
CREATE PROCEDURE SearchProducts
    @keyword NVARCHAR(100)
AS
BEGIN
    SELECT * FROM Products 
    WHERE name LIKE '%' + @keyword + '%' 
       OR description LIKE '%' + @keyword + '%'
       OR brandName LIKE '%' + @keyword + '%';
END
GO

-- Get user orders
CREATE PROCEDURE GetUserOrders
    @userId INT
AS
BEGIN
    SELECT * FROM Orders WHERE userId = @userId ORDER BY orderDate DESC;
END
GO

-- Create trigger to update product stock when order is placed
CREATE TRIGGER UpdateProductStock
ON OrderDetails
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET p.stock = p.stock - i.quantity
    FROM Products p
    INNER JOIN inserted i ON p.id = i.productId;
END
GO

-- Create views

-- Active orders view
CREATE VIEW ActiveOrdersView AS
SELECT 
    o.id, 
    o.userId, 
    u.username, 
    o.orderDate, 
    o.totalAmount, 
    o.status
FROM Orders o
JOIN Users u ON o.userId = u.id
WHERE o.status IN ('Pending', 'Processing', 'Shipped');
GO

-- Product inventory view
CREATE VIEW ProductInventoryView AS
SELECT 
    p.id,
    p.name,
    p.stock,
    c.name AS category,
    p.brandName,
    p.price
FROM Products p
JOIN Categories c ON p.categoryId = c.id;
GO

-- Create indexes for better performance
CREATE INDEX IX_Products_CategoryId ON Products(categoryId);
CREATE INDEX IX_Orders_UserId ON Orders(userId);
CREATE INDEX IX_Orders_Status ON Orders(status);