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

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    CustomerType VARCHAR(20) NOT NULL CHECK (CustomerType IN ('Walk-in', 'App'))
)