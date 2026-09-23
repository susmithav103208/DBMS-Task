CREATE DATABASE IF NOT EXISTS ProductReviewDB;

USE ProductReviewDB;

CREATE TABLE Customer (Customer_ID INT PRIMARY KEY AUTO_INCREMENT, Customer_Name VARCHAR(100) NOT NULL, Email VARCHAR(100) UNIQUE);
CREATE TABLE Product (Product_ID INT PRIMARY KEY AUTO_INCREMENT, Product_Name VARCHAR(100) NOT NULL, Category VARCHAR(50), Price DECIMAL(10,2));
CREATE TABLE Review (Review_ID INT PRIMARY KEY AUTO_INCREMENT, Customer_ID INT NOT NULL, Product_ID INT NOT NULL, Review_Text VARCHAR(500), Review_Date DATE, FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID), FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID));
CREATE TABLE Rating (Rating_ID INT PRIMARY KEY AUTO_INCREMENT, Customer_ID INT NOT NULL, Product_ID INT NOT NULL, Rating_Value INT NOT NULL, Rating_Date DATE, FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID), FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID));

INSERT INTO Customer (Customer_Name, Email) VALUES
('Arun Kumar', 'arun@gmail.com'),('Priya Sharma', 'priya@gmail.com'),('Rahul Raj', 'rahul@gmail.com'),('Divya S', 'divya@gmail.com');

INSERT INTO Product (Product_Name, Category, Price) VALUES
('Laptop', 'Electronics', 55000.00),('Keyboard', 'Electronics', 1200.00),('Mouse', 'Electronics', 700.00),('Headphones', 'Electronics', 2500.00),('Notebook', 'Stationery', 100.00);

INSERT INTO Review (Customer_ID, Product_ID, Review_Text, Review_Date) VALUES
(1, 1, 'Good laptop with excellent performance', '2026-09-10'),(2, 1, 'Very useful and good quality', '2026-09-11'),(3, 2, 'Keyboard is comfortable to use', '2026-09-12'),(4, 3, 'Good mouse for daily use', '2026-09-13'),(1, 4, 'Sound quality is very good', '2026-09-14');

INSERT INTO Rating (Customer_ID, Product_ID, Rating_Value, Rating_Date) VALUES
(1, 1, 5, '2026-09-10'),(2, 1, 4, '2026-09-11'),(3, 2, 5, '2026-09-12'),(4, 3, 3, '2026-09-13'),(1, 4, 5, '2026-09-14'),(2, 4, 4, '2026-09-15');

SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM Review;
SELECT * FROM Rating;

SELECT r.Review_ID, c.Customer_Name, p.Product_Name, r.Review_Text, r.Review_Date
FROM Review r JOIN Customer c ON r.Customer_ID = c.Customer_ID JOIN Product p ON r.Product_ID = p.Product_ID;

SELECT p.Product_ID, p.Product_Name, AVG(r.Rating_Value) AS Average_Rating
FROM Product p JOIN Rating r ON p.Product_ID = r.Product_ID GROUP BY p.Product_ID, p.Product_Name;

SELECT p.Product_ID, p.Product_Name, AVG(r.Rating_Value) AS Average_Rating
FROM Product p JOIN Rating r ON p.Product_ID = r.Product_ID GROUP BY p.Product_ID, p.Product_Name HAVING AVG(r.Rating_Value) >= 4;

SELECT p.Product_Name, COUNT(r.Rating_ID) AS Total_Ratings, AVG(r.Rating_Value) AS Average_Rating
FROM Product p JOIN Rating r ON p.Product_ID = r.Product_ID GROUP BY p.Product_ID, p.Product_Name ORDER BY Average_Rating DESC;

SELECT p.Product_Name, MAX(r.Rating_Value) AS Highest_Rating, MIN(r.Rating_Value) AS Lowest_Rating
FROM Product p JOIN Rating r ON p.Product_ID = r.Product_ID GROUP BY p.Product_ID, p.Product_Name;