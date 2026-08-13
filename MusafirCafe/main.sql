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

-- RecipeIngredients --
CREATE TABLE RecipeIngredients (
    RecipeID INT IDENTITY(1,1) PRIMARY KEY,
    ItemID INT NOT NULL,
    IngredientID INT NOT NULL,
    QuantityRequiredPerUnit DECIMAL(10, 3) NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID),
    FOREIGN KEY (IngredientID) REFERENCES Inventory(IngredientID)
)

-- CUSTOMER TABLE --
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    CustomerType VARCHAR(20) NOT NULL CHECK (CustomerType IN ('Walk-in', 'App'))
)

-- SUPPLIERS TABLE --
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20),
    Address VARCHAR(MAX)
)

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

-- INVENTORY TABLE --
CREATE TABLE Inventory (
    IngredientID INT IDENTITY(1,1) PRIMARY KEY,
    StoreID INT NOT NULL,
    IngredientName VARCHAR(100) NOT NULL,
    Unit VARCHAR(10) NOT NULL CHECK (Unit IN ('Kg', 'Litre', 'Piece', 'Pack')),
    CurrentStock DECIMAL(10, 2) NOT NULL,
    ReorderLevel DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
)

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




-- INSERT DATA --

INSERT INTO Stores (StoreName, Address, ContactNumber) VALUES  ('Musafir Cafe - Kirkee', 'Main Street, Kirkee, Pune', '9876543210')
INSERT INTO Stores (StoreName, Address, ContactNumber) VALUES ('Musafir Cafe - Camp', 'MG Road, Camp, Pune', '9876543211')


INSERT INTO MenuItems (ItemName, Category, Price, PrepTimeMinutes)
VALUES 
-- Hot Beverages --
('Espresso', 'Hot Beverage', 120.00, 3),
('Cappuccino', 'Hot Beverage', 180.00, 5),
('Latte', 'Hot Beverage', 190.00, 5),
('Masala Chai', 'Hot Beverage', 80.00, 7),
('Hot Chocolate', 'Hot Beverage', 200.00, 4),

-- Cold Beverages --
('Iced Americano', 'Cold Beverage', 150.00, 3),
('Cold Coffee', 'Cold Beverage', 220.00, 5),
('Frappe', 'Cold Beverage', 250.00, 6),
('Iced Lemon Tea', 'Cold Beverage', 130.00, 3),
('Mango Smoothie', 'Cold Beverage', 210.00, 4),

-- Snacks --
('Paneer Tikka Sandwich', 'Snack', 180.00, 8),
('Veg Samosa', 'Snack', 50.00, 2),
('French Fries', 'Snack', 120.00, 5),
('Garlic Bread', 'Snack', 140.00, 6),
('Nachos with Salsa', 'Snack', 190.00, 4),

-- Bakery --
('Butter Croissant', 'Bakery', 160.00, 2),
('Blueberry Muffin', 'Bakery', 150.00, 2),
('Chocolate Brownie', 'Bakery', 140.00, 2),
('Banana Bread', 'Bakery', 110.00, 2),
('Red Velvet Cupcake', 'Bakery', 130.00, 2)


-- CUSTOMER DATA --

INSERT INTO Customers (Name, Email, Phone, CustomerType) VALUES
('Atharv Patel', 'atharv.patel@email.com', '9870000001', 'Walk-in'),
('Anmol Sharma', 'anmol.sharma@email.com', '9870000002', 'App'),
('Abhayjeet', 'abhay.jeet@email.com', '9870000003', 'Walk-in'),
('Varsha Roy', 'varsha.roy@email.com', '9870000004', 'App'),
('Vikramjeet', 'vikram.kadam@email.com', '9870000005', 'Walk-in'),
('Niharika Singh', 'niharika.singh@email.com', '9870000006', 'App'),
('Jai Sethi', 'jai.sethi@email.com', '9870000007', 'Walk-in'),
('Neha Gupta', 'neha.gupta@email.com', '9870000008', 'App'),
('Rahul Verma', 'rahul.verma@email.com', '9870000009', 'Walk-in'),
('Pooja Iyer', 'pooja.iyer@email.com', '9870000010', 'App'),
('Karan Malhotra', 'karan.malhotra@email.com', '9870000011', 'Walk-in'),
('Anjali Patil', 'anjali.patil@email.com', '9870000012', 'App'),
('Suresh Nair', 'suresh.nair@email.com', '9870000013', 'Walk-in'),
('Kavita Reddy', 'kavita.reddy@email.com', '9870000014', 'App'),
('Manish Tiwari', 'manish.tiwari@email.com', '9870000015', 'Walk-in'),
('Riya Kapoor', 'riya.kapoor@email.com', '9870000016', 'App'),
('Aditya Sen', 'aditya.sen@email.com', '9870000017', 'Walk-in'),
('Meera Rajput', 'meera.rajput@email.com', '9870000018', 'App'),
('Sanjay Das', 'sanjay.das@email.com', '9870000019', 'Walk-in'),
('Nidhi Agarwal', 'nidhi.agarwal@email.com', '9870000020', 'App'),
('Yash Rane', 'yash.rane@email.com', '9870000021', 'Walk-in'),
('Shweta Kale', 'shweta.kale@email.com', '9870000022', 'App'),
('Arjun Menon', 'arjun.menon@email.com', '9870000023', 'Walk-in'),
('Tara Banerjee', 'tara.banerjee@email.com', '9870000024', 'App'),
('Vivek Chauhan', 'vivek.chauhan@email.com', '9870000025', 'Walk-in'),
('Kiran Bhat', 'kiran.bhat@email.com', '9870000026', 'App'),
('Sameer Kulkarni', 'sameer.kulkarni@email.com', '9870000027', 'Walk-in'),
('Rashi Mehta', 'rashi.mehta@email.com', '9870000028', 'App'),
('Deepak Thakur', 'deepak.thakur@email.com', '9870000029', 'Walk-in'),
('Divya Jha', 'divya.jha@email.com', '9870000030', 'App'),
('Prakash Munde', 'prakash.munde@email.com', '9870000031', 'Walk-in'),
('Swati Pillai', 'swati.pillai@email.com', '9870000032', 'App'),
('Nishant Yadav', 'nishant.yadav@email.com', '9870000033', 'Walk-in'),
('Aarti Mishra', 'aarti.mishra@email.com', '9870000034', 'App'),
('Kunal Ahuja', 'kunal.ahuja@email.com', '9870000035', 'Walk-in'),
('Shruti Jain', 'shruti.jain@email.com', '9870000036', 'App'),
('Rajat Saxena', 'rajat.saxena@email.com', '9870000037', 'Walk-in'),
('Pooja Bhatt', 'pooja.bhatt@email.com', '9870000038', 'App'),
('Tarun Sethi', 'tarun.sethi@email.com', '9870000039', 'Walk-in'),
('Nikita Ghosh', 'nikita.ghosh@email.com', '9870000040', 'App'),
('Harish Rao', 'harish.rao@email.com', '9870000041', 'Walk-in'),
('Simran Kaur', 'simran.kaur@email.com', '9870000042', 'App'),
('Varun Dhawan', 'varun.dhawan@email.com', '9870000043', 'Walk-in'),
('Ishita Bose', 'ishita.bose@email.com', '9870000044', 'App'),
('Prateek Sinha', 'prateek.sinha@email.com', '9870000045', 'Walk-in'),
('Sonal Mahajan', 'sonal.mahajan@email.com', '9870000046', 'App'),
('Manoj Shinde', 'manoj.shinde@email.com', '9870000047', 'Walk-in'),
('Akanksha Pande', 'akanksha.pande@email.com', '9870000048', 'App'),
('Nitin Gokhale', 'nitin.gokhale@email.com', '9870000049', 'Walk-in'),
('Deepika Wagh', 'deepika.wagh@email.com', '9870000050', 'App'),
('Ramesh Apte', 'ramesh.apte@email.com', '9870000051', 'Walk-in'),
('Shalini Dixit', 'shalini.dixit@email.com', '9870000052', 'App'),
('Ajay Soni', 'ajay.soni@email.com', '9870000053', 'Walk-in'),
('Vidya Balan', 'vidya.balan@email.com', '9870000054', 'App'),
('Kartik Aryan', 'kartik.aryan@email.com', '9870000055', 'Walk-in'),
('Kriti Sanon', 'kriti.sanon@email.com', '9870000056', 'App'),
('Mohan Bhagat', 'mohan.bhagat@email.com', '9870000057', 'Walk-in'),
('Rekha Biswas', 'rekha.biswas@email.com', '9870000058', 'App'),
('Anil Shetty', 'anil.shetty@email.com', '9870000059', 'Walk-in'),
('Sunita Varma', 'sunita.varma@email.com', '9870000060', 'App'),
('Prashant Kamble', 'prashant.kamble@email.com', '9870000061', 'Walk-in'),
('Shilpa Shinde', 'shilpa.shinde@email.com', '9870000062', 'App'),
('Naveen Kumar', 'naveen.kumar@email.com', '9870000063', 'Walk-in'),
('Jyoti Prakash', 'jyoti.prakash@email.com', '9870000064', 'App'),
('Arvind Swami', 'arvind.swami@email.com', '9870000065', 'Walk-in'),
('Meenakshi Seshadri', 'meenakshi.seshadri@email.com', '9870000066', 'App'),
('Suraj Pancholi', 'suraj.pancholi@email.com', '9870000067', 'Walk-in'),
('Richa Chadha', 'richa.chadha@email.com', '9870000068', 'App'),
('Gaurav Chopra', 'gaurav.chopra@email.com', '9870000069', 'Walk-in'),
('Nandini Datta', 'nandini.datta@email.com', '9870000070', 'App'),
('Rohan Gavaskar', 'rohan.gavaskar@email.com', '9870000071', 'Walk-in'),
('Preeti Zinta', 'preeti.zinta@email.com', '9870000072', 'App'),
('Abhishek Bachchan', 'abhishek.bachchan@email.com', '9870000073', 'Walk-in'),
('Aishwarya Rai', 'aishwarya.rai@email.com', '9870000074', 'App'),
('Siddharth Malhotra', 'siddharth.malhotra@email.com', '9870000075', 'Walk-in'),
('Kiara Advani', 'kiara.advani@email.com', '9870000076', 'App'),
('Rajkumar Rao', 'rajkumar.rao@email.com', '9870000077', 'Walk-in'),
('Patralekha Paul', 'patralekha.paul@email.com', '9870000078', 'App'),
('Ayushmann Khurrana', 'ayushmann.khurrana@email.com', '9870000079', 'Walk-in'),
('Tahira Kashyap', 'tahira.kashyap@email.com', '9870000080', 'App'),
('Vishal Pawar', 'vishal.pawar@email.com', '9870000081', 'Walk-in'),
('Mayuri Deshmukh', 'mayuri.deshmukh@email.com', '9870000082', 'App'),
('Sandeep More', 'sandeep.more@email.com', '9870000083', 'Walk-in'),
('Pallavi Jadhav', 'pallavi.jadhav@email.com', '9870000084', 'App'),
('Tushar Chavan', 'tushar.chavan@email.com', '9870000085', 'Walk-in'),
('Rutuja Bhosale', 'rutuja.bhosale@email.com', '9870000086', 'App'),
('Anand Kadam', 'anand.kadam@email.com', '9870000087', 'Walk-in'),
('Sonali Gaikwad', 'sonali.gaikwad@email.com', '9870000088', 'App'),
('Rohan Halder', 'rohan.halder@email.com', '9870000089', 'Walk-in'),
('Ananya Mukherjee', 'ananya.mukherjee@email.com', '9870000090', 'App'),
('Suman Chatterjee', 'suman.chatterjee@email.com', '9870000091', 'Walk-in'),
('Debolina Das', 'debolina.das@email.com', '9870000092', 'App'),
('Sourav Ganguly', 'sourav.ganguly@email.com', '9870000093', 'Walk-in'),
('Rupa Sengupta', 'rupa.sengupta@email.com', '9870000094', 'App'),
('Amitava Bose', 'amitava.bose@email.com', '9870000095', 'Walk-in'),
('Tanusree Dutta', 'tanusree.dutta@email.com', '9870000096', 'App'),
('Subhashish Roy', 'subhashish.roy@email.com', '9870000097', 'Walk-in'),
('Mitali Banerjee', 'mitali.banerjee@email.com', '9870000098', 'App'),
('Joydeep Nath', 'joydeep.nath@email.com', '9870000099', 'Walk-in'),
('Arpita Mazumder', 'arpita.mazumder@email.com', '9870000100', 'App'),
('Prakash Yende', 'prakash.yende@email.com', '9870000101', 'Walk-in');


-- INSERT DATA INTO Supplier --

INSERT INTO Suppliers (SupplierName, ContactNumber, Address) VALUES 
('Tata Coffee Beans', '1800112233', 'Bangalore, India'),
('Amul Dairy', '1800445566', 'Anand, Gujarat'), 
('Urban Bakery Works', '1800778899', 'Pune, Maharashtra'),
('Sleepy Owl Roasters', '1800990000', 'Delhi, India');

-- EMPLOYEE DATA --

INSERT INTO Employees (StoreID, Name, Role, Email, Phone) VALUES 
(1, 'Rahul Sharma', 'Store Manager', 'rahul@musafircafe.com', '9998887770'),
(1, 'Priya Singh', 'Barista', 'priya@musafircafe.com', '9998887771'),
(1, 'Amit Patel', 'Barista', 'amit@musafircafe.com', '9998887772'),
(2, 'Neha Gupta', 'Store Manager', 'neha@musafircafe.com', '9998887773'),
(2, 'Vikas Kumar', 'Barista', 'vikas@musafircafe.com', '9998887774'),
(1, 'System Admin', 'Admin', 'admin@musafircafe.com', '9998887775');

-- INVENTORY DATA --

INSERT INTO Inventory (StoreID, IngredientName, Unit, CurrentStock, ReorderLevel) VALUES 
(1, 'Espresso Beans', 'Kg', 15.5, 5.0),
(1, 'Milk', 'Litre', 8.0, 15.0), -- NOTE: Stock is intentionally below Reorder Level
(1, 'Sugar', 'Kg', 20.0, 10.0),
(1, 'Chocolate Syrup', 'Litre', 5.0, 2.0),
(1, 'Tea Leaves', 'Kg', 10.0, 3.0),
(1, 'Paper Cups', 'Piece', 500.0, 200.0),
(1, 'Samosa Base', 'Piece', 40.0, 20.0),
(1, 'Croissant Dough', 'Piece', 30.0, 15.0),
(1, 'Blueberry Muffin', 'Piece', 15.0, 10.0),
(1, 'Ice', 'Kg', 30.0, 10.0);

-- INSERT Orders --

INSERT INTO Orders (StoreID, CustomerID, ProcessedByEmployeeID, OrderDateTime, TotalAmount, PaymentMode, Status) VALUES 
(1, 1, 2, '2026-08-01 09:30:00', 300.00, 'UPI', 'Completed'),
(1, 2, 2, '2026-08-02 10:15:00', 120.00, 'Cash', 'Completed'),
(2, 3, 4, '2026-08-03 11:45:00', 450.00, 'Card', 'Completed'),
(1, 4, 3, '2026-08-04 14:20:00', 650.00, 'UPI', 'Completed'), 
(2, 5, 5, '2026-08-05 08:10:00', 180.00, 'Cash', 'Completed'),
(1, 6, 2, '2026-08-06 16:30:00', 200.00, 'UPI', 'Completed'),
(2, 7, 4, '2026-08-07 18:00:00', 750.00, 'Card', 'Completed'),
(1, 8, 3, '2026-08-08 09:00:00', 150.00, 'Cash', 'Completed'),
(2, 9, 5, '2026-08-09 13:20:00', 820.00, 'UPI', 'Completed'), 
(1, 10, 2, '2026-08-10 15:45:00', 330.00, 'Card', 'Pending');

-- INSERT Order Details --

INSERT INTO OrderDetails (OrderID, ItemID, Quantity, PriceAtOrder) VALUES 
-- Order 1 (Total: 300.00)
(1, 2, 1, 180.00),  -- Cappuccino
(1, 13, 1, 120.00), -- French Fries

-- Order 2 (Total: 120.00)
(2, 1, 1, 120.00),  -- Espresso

-- Order 3 (Total: 450.00)
(3, 8, 1, 250.00),  -- Frappe
(3, 5, 1, 200.00),  -- Hot Chocolate

-- Order 4 (Total: 650.00)
(4, 8, 2, 250.00),  -- 2x Frappe (500.00)
(4, 17, 1, 150.00), -- Blueberry Muffin

-- Order 5 (Total: 180.00)
(5, 11, 1, 180.00), -- Paneer Tikka Sandwich

-- Order 6 (Total: 200.00)
(6, 5, 1, 200.00),  -- Hot Chocolate

-- Order 7 (Total: 750.00)
(7, 8, 3, 250.00),  -- 3x Frappe (750.00)

-- Order 8 (Total: 150.00)
(8, 17, 1, 150.00), -- Blueberry Muffin

-- Order 9 (Total: 820.00) - Contains Hot Bev + Bakery
(9, 3, 1, 190.00),  -- Latte
(9, 16, 1, 160.00), -- Butter Croissant
(9, 8, 1, 250.00),  -- Frappe
(9, 7, 1, 220.00),  -- Cold Coffee

-- Order 10 (Total: 330.00) - Contains Hot Bev + Bakery
(10, 2, 1, 180.00), -- Cappuccino
(10, 17, 1, 150.00); -- Blueberry Muffin


-- INSERT Inventory Purchases --
INSERT INTO InventoryPurchases (StoreID, SupplierID, IngredientID, LoggedByEmployeeID, PurchaseDate, Quantity, UnitPrice) VALUES 
-- Recent active purchases (August 2026)
(1, 1, 1, 1, '2026-08-10', 10.00, 800.00), -- Tata Coffee supplying Espresso Beans
(1, 2, 2, 1, '2026-08-12', 20.00, 60.00),  -- Amul Dairy supplying Milk
(2, 3, 8, 4, '2026-08-11', 50.00, 40.00),  -- Urban Bakery supplying Croissant Dough
-- Old purchase to satisfy the "inactive supplier" query (> 3 months ago)
(1, 4, 1, 1, '2026-04-01', 5.00, 900.00);


-- INSERT into RecipeIngredients
INSERT INTO RecipeIngredients (ItemID, IngredientID, QuantityRequiredPerUnit) VALUES 
-- Recipe for Cappuccino (ItemID 2)
-- Uses Espresso Beans (1), Milk (2), and Paper Cup (6)
(2, 1, 0.015), 
(2, 2, 0.200), 
(2, 6, 1.000),

-- Recipe for Cold Coffee (ItemID 7)
-- Uses Espresso Beans (1), Milk (2), Ice (10), and Paper Cup (6)
(7, 1, 0.020), 
(7, 2, 0.250), 
(7, 10, 0.100), 
(7, 6, 1.000),

-- Recipe for Veg Samosa (ItemID 12)
-- Uses Samosa Base (7)
(12, 7, 1.000),

-- Recipe for Butter Croissant (ItemID 16)
-- Uses Croissant Dough (8)
(16, 8, 1.000),

-- Recipe for Blueberry Muffin (ItemID 17)
-- Uses Blueberry Muffin Base (9)
(17, 9, 1.000)

drop DATABASE MusafirCafe