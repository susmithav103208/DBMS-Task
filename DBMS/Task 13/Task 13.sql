USE DBMS;

CREATE ROLE 'dbms_read_only'@'localhost';
CREATE ROLE 'dbms_order_manager'@'localhost';

CREATE USER 'report_user'@'localhost' IDENTIFIED BY 'CHANGE_THIS_PASSWORD';
CREATE USER 'order_user'@'localhost' IDENTIFIED BY 'CHANGE_THIS_PASSWORD';

GRANT SELECT ON DBMS.* TO 'dbms_read_only'@'localhost';
GRANT SELECT, INSERT, UPDATE ON DBMS.Orders TO 'dbms_order_manager'@'localhost';
GRANT SELECT, INSERT ON DBMS.Payment TO 'dbms_order_manager'@'localhost';

GRANT 'dbms_read_only'@'localhost' TO 'report_user'@'localhost';
GRANT 'dbms_order_manager'@'localhost' TO 'order_user'@'localhost';

SET DEFAULT ROLE 'dbms_read_only'@'localhost' TO 'report_user'@'localhost';
SET DEFAULT ROLE 'dbms_order_manager'@'localhost' TO 'order_user'@'localhost';

REVOKE UPDATE ON DBMS.Orders FROM 'dbms_order_manager'@'localhost';

CREATE INDEX idx_customer_name ON Customer(Customer_Name);
CREATE INDEX idx_product_category ON Product(Category);
CREATE INDEX idx_orders_customer_id ON Orders(Customer_ID);
CREATE INDEX idx_orders_order_date ON Orders(Order_Date);
CREATE INDEX idx_payment_status ON Payment(Payment_Status);

ANALYZE TABLE Customer, Product, Orders, Payment;

EXPLAIN
SELECT c.Customer_Name, o.Order_ID, o.Order_Date, p.Product_Name, o.Quantity
FROM Customer c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Product p ON o.Product_ID = p.Product_ID
WHERE c.Customer_Name = 'Priya';

EXPLAIN
SELECT Payment_ID, Order_ID, Payment_Amount
FROM Payment
WHERE Payment_Status = 'Paid';

SHOW GRANTS FOR 'report_user'@'localhost';
SHOW GRANTS FOR 'order_user'@'localhost';
SHOW GRANTS FOR 'dbms_read_only'@'localhost';
SHOW GRANTS FOR 'dbms_order_manager'@'localhost';
