/* Show the top 5 best-selling items by quantity sold.*/
SELECT TOP 5 m.ItemName, SUM(od.Quantity) AS TotalQuantitySold 
FROM OrderDetails od INNER JOIN 
MenuItems m ON od.ItemID = m.ItemID 
GROUP BY 
m.ItemName 
ORDER BY TotalQuantitySold DESC

/* Calculate the total sales revenue per day for the last month.*/
SELECT CAST(OrderDateTime AS DATE) AS SalesDate, SUM(TotalAmount) AS DailyRevenue
FROM Orders
WHERE OrderDateTime >= DATEADD(day, -30, GETDATE())
GROUP BY CAST(OrderDateTime AS DATE)
ORDER BY SalesDate DESC

/* Find customers who placed more than 5 orders in the last 30 days */

SELECT c.CustomerID,c.Name, 
COUNT(o.OrderID) AS TotalOrders
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDateTime >= DATEADD(day, -30, GETDATE())
GROUP BY c.CustomerID, c.Name
HAVING COUNT(o.OrderID) > 5

/* Identify items that have not been ordered in the past month */

SELECT ItemID, ItemName 
FROM MenuItems
WHERE ItemID NOT IN (SELECT DISTINCT od.ItemID FROM OrderDetails od
INNER JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDateTime >= DATEADD(day, -30, GETDATE()))

/* List ingredients below their reorder level */

SELECT IngredientID,IngredientName,CurrentStock,ReorderLevel
FROM Inventory
WHERE CurrentStock <= ReorderLevel

/* Calculate the stock required for all pending orders */
SELECT i.IngredientName,SUM(od.Quantity * ri.QuantityRequiredPerUnit) AS TotalIngredientRequired
FROM Orders o 
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN RecipeIngredients ri ON od.ItemID = ri.ItemID
INNER JOIN Inventory i ON ri.IngredientID = i.IngredientID
WHERE o.Status = 'Pending'
GROUP BY i.IngredientName
ORDER BY TotalIngredientRequired DESC

/* Show the total amount spent with each supplier this year */
SELECT s.SupplierName,SUM(ip.Quantity * ip.UnitPrice) AS TotalSpentThisYear
FROM Suppliers s
INNER JOIN InventoryPurchases ip ON s.SupplierID = ip.SupplierID
WHERE YEAR(ip.PurchaseDate) = YEAR(GETDATE())
GROUP BY s.SupplierName
ORDER BY TotalSpentThisYear DESC

/* Identify the most frequently used ingredient in recipes */
SELECT TOP 1 i.IngredientName,
COUNT(ri.ItemID) AS NumberOfRecipesItAppearsIn
FROM Inventory i
INNER JOIN RecipeIngredients ri ON i.IngredientID = ri.IngredientID
GROUP BY i.IngredientName
ORDER BY NumberOfRecipesItAppearsIn DESC

/* Track wastage percentage of each ingredient for the current month */
SELECT * FROM Wastage  

SELECT i.IngredientName,SUM(w.QuantityLost) AS WastedQuantity,i.CurrentStock AS RemainingStock,
CAST((SUM(w.QuantityLost) / (i.CurrentStock + SUM(w.QuantityLost))) * 100 AS DECIMAL(5,2)) AS WastagePercentage
FROM Wastage w JOIN Inventory i ON w.IngredientID = i.IngredientID 
WHERE 
    MONTH(w.Date) = MONTH(GETDATE()) 
    AND YEAR(w.Date) = YEAR(GETDATE())
GROUP BY i.IngredientName, i.CurrentStock
ORDER BY WastagePercentage DESC;


/* List orders paid via UPI above ₹500*/

SELECT OrderID,OrderDateTime,CustomerID,TotalAmount,PaymentMode,Status
FROM Orders
WHERE PaymentMode = 'UPI' AND TotalAmount > 500.00
ORDER BY TotalAmount DESC

/* Find the average preparation time per order */
SELECT AVG(DATEDIFF(MINUTE, OrderDateTime, CompletionDateTime)) AS AveragePrepTimeMinutes
FROM  Orders
WHERE Status = 'Completed' AND CompletionDateTime IS NOT NULL

/* Display the total quantity of each ingredient used in the last 7 days.*/

SELECT i.IngredientName,SUM(od.Quantity * ri.QuantityRequiredPerUnit) AS TotalQuantityUsed
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN RecipeIngredients ri ON od.ItemID = ri.ItemID
INNER JOIN Inventory i ON ri.IngredientID = i.IngredientID
WHERE o.OrderDateTime >= DATEADD(day, -7, GETDATE()) AND o.Status = 'Completed'
GROUP BY i.IngredientName
ORDER BY TotalQuantityUsed DESC

/* Identify the customer who has spent the most overall.*/
SELECT TOP 1 c.CustomerID,c.Name, SUM(o.TotalAmount) AS TotalLifetimeSpend
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Status = 'Completed'
GROUP BY c.CustomerID, c.Name
ORDER BY TotalLifetimeSpend DESC

/* Show all orders containing at least one hot beverage and one bakery item.  */
SELECT od.OrderID, m.ItemName AS WhatWasOrdered, od.Quantity
FROM OrderDetails od
JOIN MenuItems m ON od.ItemID = m.ItemID
ORDER BY od.OrderID;

SELECT o.OrderID, o.OrderDateTime,o.TotalAmount
FROM Orders o JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems m ON od.ItemID = m.ItemID
WHERE m.Category IN ('Hot Beverage', 'Bakery')
GROUP BY 
    o.OrderID, 
    o.OrderDateTime,
    o.TotalAmount
HAVING COUNT(DISTINCT m.Category) = 2;

/* Find menu items with the highest profit margin (Price – Ingredient Cost) */

SELECT  m.ItemID,m.ItemName,m.Price AS SellingPrice,
SUM(ri.QuantityRequiredPerUnit * i.UnitCost) AS TotalIngredientCost,
(m.Price - SUM(ri.QuantityRequiredPerUnit * i.UnitCost)) AS ProfitMargin
FROM MenuItems m INNER JOIN RecipeIngredients ri ON m.ItemID = ri.ItemID
INNER JOIN Inventory i ON ri.IngredientID = i.IngredientID
GROUP BY  m.ItemID,  m.ItemName, m.Price
ORDER BY ProfitMargin DESC
/*
UPDATE Inventory SET UnitCost = 1200.00 WHERE IngredientID = 1; 
UPDATE Inventory SET UnitCost = 65.00 WHERE IngredientID = 2;   
UPDATE Inventory SET UnitCost = 45.00 WHERE IngredientID = 3;   
UPDATE Inventory SET UnitCost = 450.00 WHERE IngredientID = 4;  
UPDATE Inventory SET UnitCost = 400.00 WHERE IngredientID = 5;  
UPDATE Inventory SET UnitCost = 2.50 WHERE IngredientID = 6;    
UPDATE Inventory SET UnitCost = 12.00 WHERE IngredientID = 7;   
UPDATE Inventory SET UnitCost = 45.00 WHERE IngredientID = 8;   
UPDATE Inventory SET UnitCost = 55.00 WHERE IngredientID = 9;   
UPDATE Inventory SET UnitCost = 20.00 WHERE IngredientID = 10; */
SELECT * FROM Inventory

/* List suppliers who haven't supplied anything in the last 3 months. */

SELECT s.SupplierID, s.SupplierName
FROM Suppliers s
WHERE NOT EXISTS ( SELECT 1 FROM InventoryPurchases ip 
WHERE ip.SupplierID = s.SupplierID AND ip.PurchaseDate >= DATEADD(month, -3, GETDATE())
)

/* Generate a daily stock usage report for the outlet. */

SELECT CAST(o.OrderDateTime AS DATE) AS ReportDate,o.StoreID,i.IngredientName,
SUM(od.Quantity * ri.QuantityRequiredPerUnit) AS TotalQuantityUsed
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN RecipeIngredients ri ON od.ItemID = ri.ItemID
JOIN Inventory i ON ri.IngredientID = i.IngredientID 
AND o.StoreID = i.StoreID 
WHERE o.Status = 'Completed'
GROUP BY 
    CAST(o.OrderDateTime AS DATE),
    o.StoreID,
    i.IngredientName
ORDER BY ReportDate DESC, o.StoreID, TotalQuantityUsed DESC;