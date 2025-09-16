-- answers.sql
-- Database Design and Normalization Assignment
-- 🚀 Applying 1NF, 2NF, and 3NF to optimize database structure

/* 
Question 1 🛠️ Achieving 1NF (First Normal Form)
------------------------------------------------
The original ProductDetail table:

OrderID | CustomerName | Products
101     | John Doe     | Laptop, Mouse
102     | Jane Smith   | Tablet, Keyboard, Mouse
103     | Emily Clark  | Phone

❌ Problem: "Products" column contains multiple values, violating 1NF.
✅ Solution: Split into separate rows so each row has only ONE product.
*/

-- Create normalized ProductDetail_1NF table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)
);

-- Insert data in 1NF format
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),
(103, 'Emily Clark', 'Phone');


/* 
Question 2 🧩 Achieving 2NF (Second Normal Form)
------------------------------------------------
The original OrderDetails table (already in 1NF):

OrderID | CustomerName | Product   | Quantity
101     | John Doe     | Laptop    | 2
101     | John Doe     | Mouse     | 1
102     | Jane Smith   | Tablet    | 3
102     | Jane Smith   | Keyboard  | 1
102     | Jane Smith   | Mouse     | 2
103     | Emily Clark  | Phone     | 1

❌ Problem: CustomerName depends only on OrderID (partial dependency).
✅ Solution: Separate customer information into a new table (Orders),
and keep product info in another table (OrderItems).
*/

-- Create Orders table (OrderID → CustomerName)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert customer data (no duplicates, one row per order)
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Create OrderItems table (OrderID + Product → Quantity)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert order-item data (fully depends on OrderID + Product)
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);


/* 
Question 3 🧹 Achieving 3NF (Third Normal Form)
------------------------------------------------
Problem: Even in 2NF, there may be transitive dependencies.

For example:
- CustomerName actually belongs to a Customer entity, not Orders.
- Product details (like ProductName, Vendor, Price) belong in a Product table.

✅ Solution:
- Separate Customers from Orders.
- Separate Products from OrderItems.
*/

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert unique customers
INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Emily Clark');

-- Redefine Orders table to reference CustomerID instead of storing name
CREATE TABLE Orders_3NF (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Insert orders referencing CustomerID
INSERT INTO Orders_3NF (OrderID, CustomerID) VALUES
(101, 1),
(102, 2),
(103, 3);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50)
    -- (Optional: add columns like Vendor, Price, Stock)
);

-- Insert unique products
INSERT INTO Products (ProductID, ProductName) VALUES
(1, 'Laptop'),
(2, 'Mouse'),
(3, 'Tablet'),
(4, 'Keyboard'),
(5, 'Phone');

-- Create OrderItems_3NF linking Orders and Products
CREATE TABLE OrderItems_3NF (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders_3NF(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert order-item data with references
INSERT INTO OrderItems_3NF (OrderID, ProductID, Quantity) VALUES
(101, 1, 2),  -- Laptop
(101, 2, 1),  -- Mouse
(102, 3, 3),  -- Tablet
(102, 4, 1),  -- Keyboard
(102, 2, 2),  -- Mouse
(103, 5, 1);  -- Phone
