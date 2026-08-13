CREATE DATABASE MusafirCafe
USE MusafirCafe

-- STORES TABLE --
CREATE TABLE Stores (
    StoreID INT IDENTITY(1,1) PRIMARY KEY,
    StoreName VARCHAR(100) NOT NULL,
    Address VARCHAR(MAX),
    ContactNumber VARCHAR(20)
)
-- MENU ITEMS (CATEGORY MANDATED)
CREATE TABLE MenuItems (
    ItemID INT IDENTITY(1,1) PRIMARY KEY,
    ItemName VARCHAR(100) NOT NULL,
    Category VARCHAR(20) NOT NULL CHECK (Category IN ('Hot Beverage', 'Cold Beverage', 'Snack', 'Bakery')),
    Price DECIMAL(10, 2) NOT NULL,
    PrepTimeMinutes INT NOT NULL
)
-- CUSTOMER TABLE --
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    CustomerType VARCHAR(20) NOT NULL CHECK (CustomerType IN ('Walk-in', 'App'))
)

CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20),
    Address VARCHAR(MAX)
)

-- DEPENDENCY TABLES --

-- EMPLOYEE TABLE --
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL CHECK (Role IN ('Barista', 'Store Manager', 'Admin')),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
)

CREATE TABLE Inventory (
    IngredientID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    IngredientName VARCHAR(100) NOT NULL,
    Unit VARCHAR(10) NOT NULL CHECK (Unit IN ('Kg', 'Litre', 'Piece', 'Pack')),
    CurrentStock DECIMAL(10, 2) NOT NULL,
    ReorderLevel DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
)

-- SECOND ORDER DEPENDENCY TABLES --

-- ORDER TABLE --
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    CustomerID INT,
    ProcessedByEmployeeID INT NOT NULL,
    OrderDateTime DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentMode VARCHAR(10) NOT NULL CHECK (PaymentMode IN ('Cash', 'Card', 'UPI')),
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Pending', 'Completed', 'Cancelled')),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProcessedByEmployeeID) REFERENCES Employees(EmployeeID)
)

-- INGredient Table --
CREATE TABLE RecipeIngredients (
    RecipeID INT IDENTITY(1,1) PRIMARY KEY,
    ItemID INT NOT NULL,
    IngredientID INT NOT NULL,
    QuantityRequiredPerUnit DECIMAL(10, 3) NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID),
    FOREIGN KEY (IngredientID) REFERENCES Inventory(IngredientID)
)

-- INVENTORY TABLE --
CREATE TABLE InventoryPurchases (
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    SupplierID INT NOT NULL,
    IngredientID INT NOT NULL,
    LoggedByEmployeeID INT NOT NULL,
    PurchaseDate DATE NOT NULL,
    Quantity DECIMAL(10, 2) NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (IngredientID) REFERENCES Inventory(IngredientID),
    FOREIGN KEY (LoggedByEmployeeID) REFERENCES Employees(EmployeeID)
)

-- WASTAGE TABLE --
CREATE TABLE Wastage (
    WastageID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    IngredientID INT NOT NULL,
    LoggedByEmployeeID INT NOT NULL,
    Date DATE NOT NULL,
    QuantityLost DECIMAL(10, 2) NOT NULL,
    Reason VARCHAR(255),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (IngredientID) REFERENCES Inventory(IngredientID),
    FOREIGN KEY (LoggedByEmployeeID) REFERENCES Employees(EmployeeID)
)

-- THIRD ORDER DEPENDENCIES TABLES --

-- ORDER DETAILS TABLE --
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT NOT NULL,
    PriceAtOrder DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
)

-- LIST ALL TABLES --

