USE DBMS;

-- Analytical sales report
SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    SUM(o.Quantity) AS Total_Quantity_Sold,
    SUM(o.Quantity * p.Price) AS Total_Sales
FROM Product p
LEFT JOIN Orders o ON p.Product_ID = o.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Category
ORDER BY Total_Sales DESC;

-- Customer purchase analysis
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COALESCE(SUM(o.Quantity * p.Price), 0) AS Total_Purchase_Value
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
LEFT JOIN Product p ON o.Product_ID = p.Product_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Purchase_Value DESC;

-- Rank customers by purchase value
WITH CustomerSales AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        COALESCE(SUM(o.Quantity * p.Price), 0) AS Total_Purchase_Value
    FROM Customer c
    LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
    LEFT JOIN Product p ON o.Product_ID = p.Product_ID
    GROUP BY c.Customer_ID, c.Customer_Name
)
SELECT
    Customer_ID,
    Customer_Name,
    Total_Purchase_Value,
    RANK() OVER (ORDER BY Total_Purchase_Value DESC) AS Sales_Rank,
    ROW_NUMBER() OVER (ORDER BY Total_Purchase_Value DESC, Customer_ID) AS Row_Number
FROM CustomerSales;

-- Rank products by quantity sold within each category
WITH ProductSales AS (
    SELECT
        p.Product_ID,
        p.Product_Name,
        p.Category,
        COALESCE(SUM(o.Quantity), 0) AS Total_Quantity_Sold
    FROM Product p
    LEFT JOIN Orders o ON p.Product_ID = o.Product_ID
    GROUP BY p.Product_ID, p.Product_Name, p.Category
)
SELECT
    Product_ID,
    Product_Name,
    Category,
    Total_Quantity_Sold,
    RANK() OVER (
        PARTITION BY Category
        ORDER BY Total_Quantity_Sold DESC
    ) AS Category_Rank
FROM ProductSales;

-- Customer segmentation using purchase value
WITH CustomerSales AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        COUNT(DISTINCT o.Order_ID) AS Total_Orders,
        COALESCE(SUM(o.Quantity * p.Price), 0) AS Total_Purchase_Value
    FROM Customer c
    LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
    LEFT JOIN Product p ON o.Product_ID = p.Product_ID
    GROUP BY c.Customer_ID, c.Customer_Name
)
SELECT
    Customer_ID,
    Customer_Name,
    Total_Orders,
    Total_Purchase_Value,
    CASE
        WHEN Total_Purchase_Value >= 50000 THEN 'High Value'
        WHEN Total_Purchase_Value >= 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM CustomerSales
ORDER BY Total_Purchase_Value DESC;

-- Prepare customer dataset for AI models
CREATE OR REPLACE VIEW AI_Customer_Dataset AS
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders,
    COALESCE(SUM(o.Quantity), 0) AS Total_Items_Purchased,
    COALESCE(SUM(o.Quantity * p.Price), 0) AS Total_Purchase_Value,
    COALESCE(AVG(p.Price), 0) AS Average_Product_Price,
    COALESCE(MAX(o.Order_Date), NULL) AS Last_Order_Date,
    CASE
        WHEN COUNT(DISTINCT o.Order_ID) = 0 THEN 0
        ELSE DATEDIFF(CURDATE(), MAX(o.Order_Date))
    END AS Days_Since_Last_Order
FROM Customer c
LEFT JOIN Orders o ON c.Customer_ID = o.Customer_ID
LEFT JOIN Product p ON o.Product_ID = p.Product_ID
GROUP BY c.Customer_ID, c.Customer_Name;

-- Feature extraction for customer analysis
SELECT
    Customer_ID,
    Total_Orders,
    Total_Items_Purchased,
    Total_Purchase_Value,
    Average_Product_Price,
    Days_Since_Last_Order,
    CASE
        WHEN Total_Orders = 0 THEN 0
        ELSE Total_Purchase_Value / Total_Orders
    END AS Average_Order_Value,
    CASE
        WHEN Total_Items_Purchased = 0 THEN 0
        ELSE Total_Purchase_Value / Total_Items_Purchased
    END AS Average_Item_Value,
    CASE
        WHEN Days_Since_Last_Order <= 30 THEN 1
        ELSE 0
    END AS Recent_Customer_Flag
FROM AI_Customer_Dataset;

-- Display the prepared AI dataset
SELECT * FROM AI_Customer_Dataset;
