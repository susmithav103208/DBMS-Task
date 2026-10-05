CREATE DATABASE IF NOT EXISTS ProductManagement;
USE ProductManagement;

DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Category;

CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    FOREIGN KEY (category_id)
        REFERENCES Category(category_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

INSERT INTO Category (category_name, description) VALUES
('Electronics', 'Electronic devices'),
('Clothing', 'Clothing products'),
('Books', 'Educational books'),
('Home Appliances', 'Home appliances'),
('Sports', 'Sports products');

INSERT INTO Product (product_name, category_id, price, stock) VALUES
('Wireless Mouse', 1, 599, 50),
('Bluetooth Headphones', 1, 1499, 30),
('T-Shirt', 2, 499, 100),
('Jeans', 2, 1299, 40),
('Java Programming Book', 3, 799, 25),
('DBMS Fundamentals', 3, 650, 20),
('Electric Kettle', 4, 999, 15),
('Mixer Grinder', 4, 2499, 10),
('Cricket Bat', 5, 1800, 12),
('Football', 5, 700, 35);

SELECT * FROM Category;
SELECT * FROM Product;

UPDATE Product
SET price = 649
WHERE product_id = 1;

DELETE FROM Product
WHERE product_id = 10;

SELECT
    c.category_name,
    p.product_name,
    p.price,
    p.stock
FROM Category c
JOIN Product p
ON c.category_id = p.category_id
ORDER BY c.category_name;
