-- =========================================
-- DATA VALIDATION
-- =========================================

-- 1. Check total records
SELECT 'Books' AS table_name, COUNT(*) AS total_rows
FROM Books

UNION ALL

SELECT 'Customers', COUNT(*)
FROM Customers

UNION ALL

SELECT 'Orders', COUNT(*)
FROM Orders;


-- 2. Check missing values in Books
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE Title IS NULL) AS missing_title,
    COUNT(*) FILTER (WHERE Author IS NULL) AS missing_author,
    COUNT(*) FILTER (WHERE Genre IS NULL) AS missing_genre,
    COUNT(*) FILTER (WHERE Price IS NULL) AS missing_price,
    COUNT(*) FILTER (WHERE Stock IS NULL) AS missing_stock
FROM Books;


-- 3. Check missing values in Customers
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE Name IS NULL) AS missing_name,
    COUNT(*) FILTER (WHERE Email IS NULL) AS missing_email,
    COUNT(*) FILTER (WHERE City IS NULL) AS missing_city,
    COUNT(*) FILTER (WHERE Country IS NULL) AS missing_country
FROM Customers;


-- 4. Check missing values in Orders
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE Customer_ID IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE Book_ID IS NULL) AS missing_book_id,
    COUNT(*) FILTER (WHERE Order_Date IS NULL) AS missing_order_date,
    COUNT(*) FILTER (WHERE Quantity IS NULL) AS missing_quantity,
    COUNT(*) FILTER (WHERE Total_Amount IS NULL) AS missing_amount
FROM Orders;


-- 5. Check duplicate books
SELECT
    Title,
    Author,
    COUNT(*) AS duplicate_count
FROM Books
GROUP BY Title, Author
HAVING COUNT(*) > 1;


-- 6. Check duplicate customers
SELECT
    Email,
    COUNT(*) AS duplicate_count
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;


-- 7. Check invalid book prices
SELECT *
FROM Books
WHERE Price <= 0;


-- 8. Check invalid stock
SELECT *
FROM Books
WHERE Stock < 0;


-- 9. Check invalid order quantities
SELECT *
FROM Orders
WHERE Quantity <= 0;


-- 10. Check invalid order amounts
SELECT *
FROM Orders
WHERE Total_Amount < 0;