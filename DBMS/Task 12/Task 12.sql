USE DBMS;

CREATE TABLE IF NOT EXISTS Inventory (
    Product_ID INT PRIMARY KEY,
    Stock_Quantity INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    CONSTRAINT chk_stock_quantity CHECK (Stock_Quantity >= 0)
) ENGINE=InnoDB;

INSERT INTO Inventory (Product_ID, Stock_Quantity)
SELECT p.Product_ID, 50
FROM Product p
WHERE NOT EXISTS (
    SELECT 1
    FROM Inventory i
    WHERE i.Product_ID = p.Product_ID
);

ALTER TABLE Orders ENGINE=InnoDB;
ALTER TABLE Payment ENGINE=InnoDB;

DELIMITER //

CREATE PROCEDURE Place_Order_Transaction(
    IN p_Order_ID INT,
    IN p_Payment_ID INT,
    IN p_Customer_ID INT,
    IN p_Product_ID INT,
    IN p_Quantity INT
)
BEGIN
    DECLARE v_Stock INT DEFAULT 0;
    DECLARE v_Price DECIMAL(12,2) DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_Quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    SELECT Stock_Quantity
    INTO v_Stock
    FROM Inventory
    WHERE Product_ID = p_Product_ID
    FOR UPDATE;

    IF v_Stock IS NULL OR v_Stock < p_Quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;

    SELECT Price
    INTO v_Price
    FROM Product
    WHERE Product_ID = p_Product_ID;

    INSERT INTO Orders (
        Order_ID, Customer_ID, Product_ID, Order_Date, Quantity
    )
    VALUES (
        p_Order_ID, p_Customer_ID, p_Product_ID, CURDATE(), p_Quantity
    );

    INSERT INTO Payment (
        Payment_ID, Order_ID, Payment_Date, Payment_Status, Payment_Amount
    )
    VALUES (
        p_Payment_ID, p_Order_ID, CURDATE(), 'Paid', v_Price * p_Quantity
    );

    UPDATE Inventory
    SET Stock_Quantity = Stock_Quantity - p_Quantity
    WHERE Product_ID = p_Product_ID;

    COMMIT;
END //

DELIMITER ;

START TRANSACTION;

UPDATE Inventory
SET Stock_Quantity = Stock_Quantity - 1
WHERE Product_ID = 201;

ROLLBACK;

SELECT * FROM Inventory;

CALL Place_Order_Transaction(306, 406, 101, 201, 1);

SELECT * FROM Orders WHERE Order_ID = 306;
SELECT * FROM Payment WHERE Order_ID = 306;
SELECT * FROM Inventory WHERE Product_ID = 201;

START TRANSACTION;

UPDATE Inventory
SET Stock_Quantity = Stock_Quantity - 1000
WHERE Product_ID = 201;

ROLLBACK;

SELECT * FROM Inventory WHERE Product_ID = 201;

SELECT
    o.Order_ID,
    c.Customer_Name,
    p.Product_Name,
    o.Quantity,
    pay.Payment_Status,
    pay.Payment_Amount,
    i.Stock_Quantity
FROM Orders o
JOIN Customer c ON o.Customer_ID = c.Customer_ID
JOIN Product p ON o.Product_ID = p.Product_ID
JOIN Payment pay ON o.Order_ID = pay.Order_ID
JOIN Inventory i ON p.Product_ID = i.Product_ID
WHERE o.Order_ID = 306;
