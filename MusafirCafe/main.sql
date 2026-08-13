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

