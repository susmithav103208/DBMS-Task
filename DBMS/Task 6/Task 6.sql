USE ProductReviewDB;

DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Review;

CREATE TABLE Review (
    Review_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_ID INT,
    Review_Text VARCHAR(255),
    Review_Date DATE
);

CREATE TABLE Rating (
    Rating_ID INT PRIMARY KEY,
    Review_ID INT,
    Rating INT,
    FOREIGN KEY (Review_ID) REFERENCES Review(Review_ID)
);

INSERT INTO Review
(Review_ID, Customer_ID, Product_ID, Review_Text, Review_Date)
VALUES
(1, 101, 201, 'Good product', '2026-09-01'),
(2, 102, 201, 'Very useful', '2026-09-03'),
(3, 103, 202, 'Average quality', '2026-09-05'),
(4, 104, 203, 'Excellent product', '2026-09-07'),
(5, 105, 203, 'Worth the price', '2026-09-09');

INSERT INTO Rating
(Rating_ID, Review_ID, Rating)
VALUES
(1, 1, 4),
(2, 2, 5),
(3, 3, 3),
(4, 4, 5),
(5, 5, 4);

SELECT * FROM Review;

SELECT * FROM Rating;

SELECT
    r.Review_ID,
    r.Customer_ID,
    r.Product_ID,
    r.Review_Text,
    r.Review_Date,
    rt.Rating
FROM Review r
INNER JOIN Rating rt
ON r.Review_ID = rt.Review_ID;

SELECT
    r.Product_ID,
    AVG(rt.Rating) AS Average_Rating
FROM Review r
INNER JOIN Rating rt
ON r.Review_ID = rt.Review_ID
GROUP BY r.Product_ID;

SELECT
    r.Product_ID,
    AVG(rt.Rating) AS Average_Rating
FROM Review r
INNER JOIN Rating rt
ON r.Review_ID = rt.Review_ID
GROUP BY r.Product_ID
HAVING AVG(rt.Rating) >= 4;
