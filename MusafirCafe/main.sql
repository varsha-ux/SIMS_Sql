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
/*
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
--(1, 1, 2, '2026-08-01 09:30:00', 300.00, 'UPI', 'Completed'),
--(1, 2, 2, '2026-08-02 10:15:00', 120.00, 'Cash', 'Completed'),
--(2, 3, 4, '2026-08-03 11:45:00', 450.00, 'Card', 'Completed'),
--(1, 4, 3, '2026-08-04 14:20:00', 650.00, 'UPI', 'Completed'), 
--(2, 5, 5, '2026-08-05 08:10:00', 180.00, 'Cash', 'Completed'),
--(1, 6, 2, '2026-08-06 16:30:00', 200.00, 'UPI', 'Completed'),
--(2, 7, 4, '2026-08-07 18:00:00', 750.00, 'Card', 'Completed'),
--(1, 8, 3, '2026-08-08 09:00:00', 150.00, 'Cash', 'Completed'),
--(2, 9, 5, '2026-08-09 13:20:00', 820.00, 'UPI', 'Completed'), 
--(1, 10, 2, '2026-08-10 15:45:00', 330.00, 'Card', 'Pending'),
--(1, 12, 2, '2026-08-01 08:30:00', 180.00, 'UPI', 'Completed'), (2, 45, 4, '2026-08-01 09:15:00', 180.00, 'Cash', 'Completed'),
--(1, 88, 3, '2026-08-01 10:00:00', 180.00, 'Card', 'Completed'), (2, 23, 5, '2026-08-01 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 91, 2, '2026-08-01 13:45:00', 180.00, 'Cash', 'Completed'), (2, 17, 4, '2026-08-01 15:30:00', 180.00, 'UPI', 'Completed'),
--(1, 33, 3, '2026-08-02 08:30:00', 180.00, 'Card', 'Completed'), (2, 56, 5, '2026-08-02 09:15:00', 180.00, 'UPI', 'Completed'),
--(1, 74, 2, '2026-08-02 10:00:00', 180.00, 'Cash', 'Completed'), (2, 8, 4, '2026-08-02 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 12, 3, '2026-08-03 08:30:00', 180.00, 'Card', 'Completed'), (2, 45, 5, '2026-08-03 09:15:00', 180.00, 'UPI', 'Completed'),
--(1, 88, 2, '2026-08-03 10:00:00', 180.00, 'Cash', 'Completed'), (2, 23, 4, '2026-08-03 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 91, 3, '2026-08-04 08:30:00', 180.00, 'Card', 'Completed'), (2, 17, 5, '2026-08-04 09:15:00', 180.00, 'UPI', 'Completed'),
--(1, 33, 2, '2026-08-04 10:00:00', 180.00, 'Cash', 'Completed'), (2, 56, 4, '2026-08-04 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 74, 3, '2026-08-05 08:30:00', 180.00, 'Card', 'Completed'), (2, 8, 5, '2026-08-05 09:15:00', 180.00, 'UPI', 'Completed'),
--(1, 14, 2, '2026-08-05 10:00:00', 180.00, 'Cash', 'Completed'), (2, 21, 4, '2026-08-05 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 36, 3, '2026-08-06 08:30:00', 180.00, 'Card', 'Completed'), (2, 49, 5, '2026-08-06 09:15:00', 180.00, 'UPI', 'Completed'),
--(1, 58, 2, '2026-08-06 10:00:00', 180.00, 'Cash', 'Completed'), (2, 62, 4, '2026-08-06 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 77, 3, '2026-08-07 08:30:00', 180.00, 'Card', 'Completed'), (2, 84, 5, '2026-08-07 09:15:00', 180.00, 'UPI', 'Completed'),
--(1, 92, 2, '2026-08-07 10:00:00', 180.00, 'Cash', 'Completed'), (2, 11, 4, '2026-08-07 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 15, 3, '2026-08-08 08:30:00', 180.00, 'Card', 'Completed'), (2, 29, 5, '2026-08-08 09:15:00', 180.00, 'UPI', 'Completed'),
--(1, 42, 2, '2026-08-08 10:00:00', 180.00, 'Cash', 'Completed'), (2, 51, 4, '2026-08-08 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 65, 3, '2026-08-09 08:30:00', 180.00, 'Card', 'Completed'), (2, 73, 5, '2026-08-09 09:15:00', 180.00, 'UPI', 'Completed'),
--(1, 81, 2, '2026-08-09 10:00:00', 180.00, 'Cash', 'Completed'), (2, 95, 4, '2026-08-09 11:20:00', 180.00, 'UPI', 'Completed'),
--(1, 22, 3, '2026-08-10 08:30:00', 180.00, 'Card', 'Completed'), (2, 34, 5, '2026-08-10 09:15:00', 180.00, 'UPI', 'Completed'),

---- Combo 2 (250.00)
--(1, 47, 2, '2026-08-01 12:00:00', 250.00, 'UPI', 'Completed'), (2, 52, 4, '2026-08-01 12:45:00', 250.00, 'Cash', 'Completed'),
--(1, 68, 3, '2026-08-01 14:00:00', 250.00, 'Card', 'Completed'), (2, 79, 5, '2026-08-01 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 85, 2, '2026-08-02 12:00:00', 250.00, 'Cash', 'Completed'), (2, 97, 4, '2026-08-02 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 13, 3, '2026-08-02 14:00:00', 250.00, 'Card', 'Completed'), (2, 26, 5, '2026-08-02 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 38, 2, '2026-08-03 12:00:00', 250.00, 'Cash', 'Completed'), (2, 41, 4, '2026-08-03 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 55, 3, '2026-08-03 14:00:00', 250.00, 'Card', 'Completed'), (2, 63, 5, '2026-08-03 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 71, 2, '2026-08-04 12:00:00', 250.00, 'Cash', 'Completed'), (2, 89, 4, '2026-08-04 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 94, 3, '2026-08-04 14:00:00', 250.00, 'Card', 'Completed'), (2, 16, 5, '2026-08-04 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 24, 2, '2026-08-05 12:00:00', 250.00, 'Cash', 'Completed'), (2, 31, 4, '2026-08-05 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 46, 3, '2026-08-05 14:00:00', 250.00, 'Card', 'Completed'), (2, 59, 5, '2026-08-05 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 64, 2, '2026-08-06 12:00:00', 250.00, 'Cash', 'Completed'), (2, 75, 4, '2026-08-06 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 82, 3, '2026-08-06 14:00:00', 250.00, 'Card', 'Completed'), (2, 93, 5, '2026-08-06 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 18, 2, '2026-08-07 12:00:00', 250.00, 'Cash', 'Completed'), (2, 27, 4, '2026-08-07 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 39, 3, '2026-08-07 14:00:00', 250.00, 'Card', 'Completed'), (2, 43, 5, '2026-08-07 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 51, 2, '2026-08-08 12:00:00', 250.00, 'Cash', 'Completed'), (2, 66, 4, '2026-08-08 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 72, 3, '2026-08-08 14:00:00', 250.00, 'Card', 'Completed'), (2, 87, 5, '2026-08-08 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 91, 2, '2026-08-09 12:00:00', 250.00, 'Cash', 'Completed'), (2, 14, 4, '2026-08-09 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 25, 3, '2026-08-09 14:00:00', 250.00, 'Card', 'Completed'), (2, 36, 5, '2026-08-09 16:20:00', 250.00, 'UPI', 'Completed'),
--(1, 48, 2, '2026-08-10 12:00:00', 250.00, 'Cash', 'Completed'), (2, 54, 4, '2026-08-10 12:45:00', 250.00, 'UPI', 'Completed'),
--(1, 61, 3, '2026-08-10 14:00:00', 250.00, 'Card', 'Completed'), (2, 77, 5, '2026-08-10 16:20:00', 250.00, 'UPI', 'Completed'),

--(1, 83, 2, '2026-08-01 17:00:00', 330.00, 'UPI', 'Completed'), (2, 96, 4, '2026-08-01 17:45:00', 330.00, 'Cash', 'Completed'),
--(1, 12, 3, '2026-08-01 18:30:00', 330.00, 'Card', 'Completed'), (2, 28, 5, '2026-08-01 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 35, 2, '2026-08-02 17:00:00', 330.00, 'Cash', 'Completed'), (2, 49, 4, '2026-08-02 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 52, 3, '2026-08-02 18:30:00', 330.00, 'Card', 'Completed'), (2, 67, 5, '2026-08-02 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 74, 2, '2026-08-03 17:00:00', 330.00, 'Cash', 'Completed'), (2, 81, 4, '2026-08-03 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 95, 3, '2026-08-03 18:30:00', 330.00, 'Card', 'Completed'), (2, 13, 5, '2026-08-03 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 22, 2, '2026-08-04 17:00:00', 330.00, 'Cash', 'Completed'), (2, 37, 4, '2026-08-04 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 44, 3, '2026-08-04 18:30:00', 330.00, 'Card', 'Completed'), (2, 59, 5, '2026-08-04 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 62, 2, '2026-08-05 17:00:00', 330.00, 'Cash', 'Completed'), (2, 78, 4, '2026-08-05 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 85, 3, '2026-08-05 18:30:00', 330.00, 'Card', 'Completed'), (2, 91, 5, '2026-08-05 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 18, 2, '2026-08-06 17:00:00', 330.00, 'Cash', 'Completed'), (2, 25, 4, '2026-08-06 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 31, 3, '2026-08-06 18:30:00', 330.00, 'Card', 'Completed'), (2, 47, 5, '2026-08-06 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 54, 2, '2026-08-07 17:00:00', 330.00, 'Cash', 'Completed'), (2, 69, 4, '2026-08-07 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 76, 3, '2026-08-07 18:30:00', 330.00, 'Card', 'Completed'), (2, 82, 5, '2026-08-07 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 98, 2, '2026-08-08 17:00:00', 330.00, 'Cash', 'Completed'), (2, 11, 4, '2026-08-08 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 27, 3, '2026-08-08 18:30:00', 330.00, 'Card', 'Completed'), (2, 33, 5, '2026-08-08 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 49, 2, '2026-08-09 17:00:00', 330.00, 'Cash', 'Completed'), (2, 55, 4, '2026-08-09 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 62, 3, '2026-08-09 18:30:00', 330.00, 'Card', 'Completed'), (2, 71, 5, '2026-08-09 19:15:00', 330.00, 'UPI', 'Completed'),
--(1, 88, 2, '2026-08-10 17:00:00', 330.00, 'Cash', 'Completed'), (2, 94, 4, '2026-08-10 17:45:00', 330.00, 'UPI', 'Completed'),
--(1, 15, 3, '2026-08-10 18:30:00', 330.00, 'Card', 'Completed'), (2, 21, 5, '2026-08-10 19:15:00', 330.00, 'UPI', 'Completed'),

---- Combo 4 (150.00)
--(1, 32, 2, '2026-08-01 20:00:00', 150.00, 'UPI', 'Completed'), (2, 45, 4, '2026-08-01 20:45:00', 150.00, 'Cash', 'Completed'),
--(1, 58, 3, '2026-08-01 21:30:00', 150.00, 'Card', 'Completed'), (2, 63, 5, '2026-08-01 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 71, 2, '2026-08-02 20:00:00', 150.00, 'Cash', 'Completed'), (2, 87, 4, '2026-08-02 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 93, 3, '2026-08-02 21:30:00', 150.00, 'Card', 'Completed'), (2, 16, 5, '2026-08-02 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 24, 2, '2026-08-03 20:00:00', 150.00, 'Cash', 'Completed'), (2, 31, 4, '2026-08-03 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 45, 3, '2026-08-03 21:30:00', 150.00, 'Card', 'Completed'), (2, 59, 5, '2026-08-03 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 62, 2, '2026-08-04 20:00:00', 150.00, 'Cash', 'Completed'), (2, 78, 4, '2026-08-04 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 85, 3, '2026-08-04 21:30:00', 150.00, 'Card', 'Completed'), (2, 91, 5, '2026-08-04 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 18, 2, '2026-08-05 20:00:00', 150.00, 'Cash', 'Completed'), (2, 25, 4, '2026-08-05 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 31, 3, '2026-08-05 21:30:00', 150.00, 'Card', 'Completed'), (2, 47, 5, '2026-08-05 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 54, 2, '2026-08-06 20:00:00', 150.00, 'Cash', 'Completed'), (2, 69, 4, '2026-08-06 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 76, 3, '2026-08-06 21:30:00', 150.00, 'Card', 'Completed'), (2, 82, 5, '2026-08-06 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 98, 2, '2026-08-07 20:00:00', 150.00, 'Cash', 'Completed'), (2, 11, 4, '2026-08-07 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 27, 3, '2026-08-07 21:30:00', 150.00, 'Card', 'Completed'), (2, 33, 5, '2026-08-07 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 49, 2, '2026-08-08 20:00:00', 150.00, 'Cash', 'Completed'), (2, 55, 4, '2026-08-08 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 62, 3, '2026-08-08 21:30:00', 150.00, 'Card', 'Completed'), (2, 71, 5, '2026-08-08 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 88, 2, '2026-08-09 20:00:00', 150.00, 'Cash', 'Completed'), (2, 94, 4, '2026-08-09 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 15, 3, '2026-08-09 21:30:00', 150.00, 'Card', 'Completed'), (2, 21, 5, '2026-08-09 22:15:00', 150.00, 'UPI', 'Completed'),
--(1, 36, 2, '2026-08-10 20:00:00', 150.00, 'Cash', 'Completed'), (2, 42, 4, '2026-08-10 20:45:00', 150.00, 'UPI', 'Completed'),
--(1, 55, 3, '2026-08-10 21:30:00', 150.00, 'Card', 'Completed'), (2, 68, 5, '2026-08-10 22:15:00', 150.00, 'UPI', 'Completed'),

---- Combo 5 (200.00)
--(1, 74, 2, '2026-08-01 07:30:00', 200.00, 'UPI', 'Completed'), (2, 85, 4, '2026-08-01 08:15:00', 200.00, 'Cash', 'Completed'),
--(1, 91, 3, '2026-08-02 07:30:00', 200.00, 'Card', 'Completed'), (2, 12, 5, '2026-08-02 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 24, 2, '2026-08-03 07:30:00', 200.00, 'Cash', 'Completed'), (2, 36, 4, '2026-08-03 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 48, 3, '2026-08-04 07:30:00', 200.00, 'Card', 'Completed'), (2, 52, 5, '2026-08-04 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 65, 2, '2026-08-05 07:30:00', 200.00, 'Cash', 'Completed'), (2, 79, 4, '2026-08-05 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 81, 3, '2026-08-06 07:30:00', 200.00, 'Card', 'Completed'), (2, 93, 5, '2026-08-06 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 14, 2, '2026-08-07 07:30:00', 200.00, 'Cash', 'Completed'), (2, 27, 4, '2026-08-07 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 39, 3, '2026-08-08 07:30:00', 200.00, 'Card', 'Completed'), (2, 45, 5, '2026-08-08 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 57, 2, '2026-08-09 07:30:00', 200.00, 'Cash', 'Completed'), (2, 62, 4, '2026-08-09 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 71, 3, '2026-08-10 07:30:00', 200.00, 'Card', 'Completed'), (2, 88, 5, '2026-08-10 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 95, 2, '2026-08-11 07:30:00', 200.00, 'Cash', 'Completed'), (2, 11, 4, '2026-08-11 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 22, 3, '2026-08-12 07:30:00', 200.00, 'Card', 'Completed'), (2, 34, 5, '2026-08-12 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 46, 2, '2026-08-13 07:30:00', 200.00, 'Cash', 'Completed'), (2, 59, 4, '2026-08-13 08:15:00', 200.00, 'UPI', 'Completed'),
--(1, 64, 3, '2026-08-13 09:30:00', 200.00, 'Card', 'Completed'), (2, 75, 5, '2026-08-13 10:15:00', 200.00, 'UPI', 'Completed'),
--(1, 82, 2, '2026-08-13 11:30:00', 200.00, 'Cash', 'Completed'), (2, 93, 4, '2026-08-13 12:15:00', 200.00, 'UPI', 'Completed'),
--(1, 18, 3, '2026-08-13 13:30:00', 200.00, 'Card', 'Completed'), (2, 27, 5, '2026-08-13 14:15:00', 200.00, 'UPI', 'Completed'),
--(1, 39, 2, '2026-08-13 15:30:00', 200.00, 'Cash', 'Completed'), (2, 43, 4, '2026-08-13 16:15:00', 200.00, 'UPI', 'Completed'),
--(1, 51, 3, '2026-08-13 17:30:00', 200.00, 'Card', 'Completed'), (2, 66, 5, '2026-08-13 18:15:00', 200.00, 'UPI', 'Completed'),
--(1, 72, 2, '2026-08-13 19:30:00', 200.00, 'Cash', 'Completed'), (2, 87, 4, '2026-08-13 20:15:00', 200.00, 'UPI', 'Completed'),
(1, 91, 3, '2026-08-13 21:30:00', 200.00, 'Card', 'Completed');


-- INSERT Order Details --

INSERT INTO OrderDetails (OrderID, ItemID, Quantity, PriceAtOrder) VALUES 
(1, 2, 1, 180.00),  -- Cappuccino
(1, 13, 1, 120.00), -- French Fries

(2, 1, 1, 120.00),  -- Espresso

(3, 8, 1, 250.00),  -- Frappe
(3, 5, 1, 200.00),  -- Hot Chocolate

(4, 8, 2, 250.00),  -- 2x Frappe (500.00)
(4, 17, 1, 150.00), -- Blueberry Muffin

(5, 11, 1, 180.00), -- Paneer Tikka Sandwich

(6, 5, 1, 200.00),  -- Hot Chocolate

(7, 8, 3, 250.00),  -- 3x Frappe (750.00)

(8, 17, 1, 150.00), -- Blueberry Muffin

(9, 3, 1, 190.00),  -- Latte
(9, 16, 1, 160.00), -- Butter Croissant
(9, 8, 1, 250.00),  -- Frappe
(9, 7, 1, 220.00),  -- Cold Coffee

(10, 2, 1, 180.00), -- Cappuccino
(10, 17, 1, 150.00), -- Blueberry Muffin
(11, 2, 1, 180.00), (12, 2, 1, 180.00), (13, 2, 1, 180.00), 
(14, 2, 1, 180.00), (15, 2, 1, 180.00), 
(16, 2, 1, 180.00), (17, 2, 1, 180.00), (18, 2, 1, 180.00), 
(19, 2, 1, 180.00), (20, 2, 1, 180.00), 
(21, 2, 1, 180.00), (22, 2, 1, 180.00), (23, 2, 1, 180.00), 
(24, 2, 1, 180.00), (25, 2, 1, 180.00), 
(26, 2, 1, 180.00), (27, 2, 1, 180.00), (28, 2, 1, 180.00), 
(29, 2, 1, 180.00), (30, 2, 1, 180.00), 
(31, 2, 1, 180.00), (32, 2, 1, 180.00), (33, 2, 1, 180.00), 
(34, 2, 1, 180.00), (35, 2, 1, 180.00), 
(36, 2, 1, 180.00), (37, 2, 1, 180.00), (38, 2, 1, 180.00), 
(39, 2, 1, 180.00), (40, 2, 1, 180.00),
(41, 8, 1, 250.00), (42, 8, 1, 250.00), (43, 8, 1, 250.00), (44, 8, 1, 250.00), (45, 8, 1, 250.00), 
(46, 8, 1, 250.00), (47, 8, 1, 250.00), (48, 8, 1, 250.00), (49, 8, 1, 250.00), (50, 8, 1, 250.00), 
(51, 8, 1, 250.00), (52, 8, 1, 250.00), (53, 8, 1, 250.00), (54, 8, 1, 250.00), (55, 8, 1, 250.00), 
(56, 8, 1, 250.00), (57, 8, 1, 250.00), (58, 8, 1, 250.00), (59, 8, 1, 250.00), (60, 8, 1, 250.00), 
(61, 8, 1, 250.00), (62, 8, 1, 250.00), (63, 8, 1, 250.00), (64, 8, 1, 250.00), (65, 8, 1, 250.00), 
(66, 8, 1, 250.00), (67, 8, 1, 250.00), (68, 8, 1, 250.00), (69, 8, 1, 250.00), (70, 8, 1, 250.00), 
(71, 8, 1, 250.00), (72, 8, 1, 250.00), (73, 8, 1, 250.00), (74, 8, 1, 250.00), (75, 8, 1, 250.00), 
(76, 8, 1, 250.00), (77, 8, 1, 250.00), (78, 8, 1, 250.00), (79, 8, 1, 250.00), (80, 8, 1, 250.00),
(81, 2, 1, 180.00), (81, 17, 1, 150.00), (82, 2, 1, 180.00), (82, 17, 1, 150.00), 
(83, 2, 1, 180.00), (83, 17, 1, 150.00), (84, 2, 1, 180.00), (84, 17, 1, 150.00), 
(85, 2, 1, 180.00), (85, 17, 1, 150.00), (86, 2, 1, 180.00), (86, 17, 1, 150.00), 
(87, 2, 1, 180.00), (87, 17, 1, 150.00), (88, 2, 1, 180.00), (88, 17, 1, 150.00), 
(89, 2, 1, 180.00), (89, 17, 1, 150.00), (90, 2, 1, 180.00), (90, 17, 1, 150.00), 
(91, 2, 1, 180.00), (91, 17, 1, 150.00), (92, 2, 1, 180.00), (92, 17, 1, 150.00), 
(93, 2, 1, 180.00), (93, 17, 1, 150.00), (94, 2, 1, 180.00), (94, 17, 1, 150.00), 
(95, 2, 1, 180.00), (95, 17, 1, 150.00), (96, 2, 1, 180.00), (96, 17, 1, 150.00), 
(97, 2, 1, 180.00), (97, 17, 1, 150.00), (98, 2, 1, 180.00), (98, 17, 1, 150.00), 
(99, 2, 1, 180.00), (99, 17, 1, 150.00), (100, 2, 1, 180.00), (100, 17, 1, 150.00),
(101, 2, 1, 180.00), (101, 17, 1, 150.00), (102, 2, 1, 180.00), (102, 17, 1, 150.00), 
(103, 2, 1, 180.00), (103, 17, 1, 150.00), (104, 2, 1, 180.00), (104, 17, 1, 150.00), 
(105, 2, 1, 180.00), (105, 17, 1, 150.00), (106, 2, 1, 180.00), (106, 17, 1, 150.00), 
(107, 2, 1, 180.00), (107, 17, 1, 150.00), (108, 2, 1, 180.00), (108, 17, 1, 150.00), 
(109, 2, 1, 180.00), (109, 17, 1, 150.00), (110, 2, 1, 180.00), (110, 17, 1, 150.00), 
(111, 2, 1, 180.00), (111, 17, 1, 150.00), (112, 2, 1, 180.00), (112, 17, 1, 150.00), 
(113, 2, 1, 180.00), (113, 17, 1, 150.00), (114, 2, 1, 180.00), (114, 17, 1, 150.00), 
(115, 2, 1, 180.00), (115, 17, 1, 150.00), (116, 2, 1, 180.00), (116, 17, 1, 150.00), 
(117, 2, 1, 180.00), (117, 17, 1, 150.00), (118, 2, 1, 180.00), (118, 17, 1, 150.00), 
(119, 2, 1, 180.00), (119, 17, 1, 150.00), (120, 2, 1, 180.00), (120, 17, 1, 150.00),

(121, 17, 1, 150.00), (122, 17, 1, 150.00), (123, 17, 1, 150.00), (124, 17, 1, 150.00), (125, 17, 1, 150.00), 
(126, 17, 1, 150.00), (127, 17, 1, 150.00), (128, 17, 1, 150.00), (129, 17, 1, 150.00), (130, 17, 1, 150.00), 
(131, 17, 1, 150.00), (132, 17, 1, 150.00), (133, 17, 1, 150.00), (134, 17, 1, 150.00), (135, 17, 1, 150.00), 
(136, 17, 1, 150.00), (137, 17, 1, 150.00), (138, 17, 1, 150.00), (139, 17, 1, 150.00), (140, 17, 1, 150.00), 
(141, 17, 1, 150.00), (142, 17, 1, 150.00), (143, 17, 1, 150.00), (144, 17, 1, 150.00), (145, 17, 1, 150.00), 
(146, 17, 1, 150.00), (147, 17, 1, 150.00), (148, 17, 1, 150.00), (149, 17, 1, 150.00), (150, 17, 1, 150.00), 
(151, 17, 1, 150.00), (152, 17, 1, 150.00), (153, 17, 1, 150.00), (154, 17, 1, 150.00), (155, 17, 1, 150.00), 
(156, 17, 1, 150.00), (157, 17, 1, 150.00), (158, 17, 1, 150.00), (159, 17, 1, 150.00), (160, 17, 1, 150.00),

(161, 5, 1, 200.00), (162, 5, 1, 200.00), (163, 5, 1, 200.00), (164, 5, 1, 200.00), (165, 5, 1, 200.00), 
(166, 5, 1, 200.00), (167, 5, 1, 200.00), (168, 5, 1, 200.00), (169, 5, 1, 200.00), (170, 5, 1, 200.00), 
(171, 5, 1, 200.00), (172, 5, 1, 200.00), (173, 5, 1, 200.00), (174, 5, 1, 200.00), (175, 5, 1, 200.00), 
(176, 5, 1, 200.00), (177, 5, 1, 200.00), (178, 5, 1, 200.00), (179, 5, 1, 200.00), (180, 5, 1, 200.00), 
(181, 5, 1, 200.00), (182, 5, 1, 200.00), (183, 5, 1, 200.00), (184, 5, 1, 200.00), (185, 5, 1, 200.00), 
(186, 5, 1, 200.00), (187, 5, 1, 200.00), (188, 5, 1, 200.00), (189, 5, 1, 200.00), (190, 5, 1, 200.00), 
(191, 5, 1, 200.00), (192, 5, 1, 200.00), (193, 5, 1, 200.00), (194, 5, 1, 200.00), (195, 5, 1, 200.00), 
(196, 5, 1, 200.00), (197, 5, 1, 200.00), (198, 5, 1, 200.00), (199, 5, 1, 200.00), (200, 5, 1, 200.00),
(201, 5, 1, 200.00),(202, 5, 1, 250.00),(203, 5, 1, 300.00),(204, 5, 1, 600.00),(205, 5, 1, 300.00),
(206, 5, 1, 400.00),(207, 5, 1, 350.00),(208, 5, 1, 450.00),(209, 5, 1, 200.00),(209, 5, 1, 200.00);


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
(12, 7, 1.000),
(16, 8, 1.000),
(17, 9, 1.000)

-- INSERT WASTAGE TABLE -- 
INSERT INTO Wastage (StoreID, IngredientID, LoggedByEmployeeID, Date, QuantityLost, Reason) 
VALUES 
-- Store 1 
(1, 2, 2, '2026-08-10', 1.50, 'Milk spilled during morning rush'),
(1, 1, 3, '2026-08-12', 0.25, 'Espresso beans dropped on the floor'),
(1, 6, 2, '2026-08-13', 5.00, 'Paper cups crushed by accident in storage'),

-- Store 2 
(2, 8, 4, '2026-08-11', 2.00, 'Croissant dough over-proofed and ruined'),
(2, 2, 5, '2026-08-13', 2.00, 'Milk expired due to fridge cooling issue'),
(2, 7, 4, '2026-08-13', 3.00, 'Samosa base burnt during prep');
*/

select * from Customers
select * from Employees
select * from Inventory
select * from InventoryPurchases
select * from MenuItems
select * from Orders
select * from OrderDetails
select * from RecipeIngredients
select * from Stores
select * from Suppliers
select * from Wastage