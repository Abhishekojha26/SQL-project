-- =========================================
-- BASIC SALES & BUSINESS ANALYSIS
-- =========================================


-- 1. Total Revenue
SELECT
    ROUND(SUM(Total_Amount), 2) AS total_revenue
FROM Orders;


-- 2. Total Orders
SELECT
    COUNT(*) AS total_orders
FROM Orders;


-- 3. Total Books Sold
SELECT
    SUM(Quantity) AS total_books_sold
FROM Orders;


-- 4. Average Order Value
SELECT
    ROUND(AVG(Total_Amount), 2) AS average_order_value
FROM Orders;


-- 5. Top 10 Best-Selling Books
SELECT
    b.Title,
    b.Author,
    b.Genre,
    SUM(o.Quantity) AS units_sold,
    ROUND(SUM(o.Total_Amount), 2) AS revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre
ORDER BY units_sold DESC
LIMIT 10;


-- 6. Genre Performance
SELECT
    b.Genre,
    SUM(o.Quantity) AS books_sold,
    ROUND(SUM(o.Total_Amount), 2) AS revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY revenue DESC;


-- 7. Top 10 Customers by Spending
SELECT
    c.Customer_ID,
    c.Name,
    c.City,
    c.Country,
    COUNT(o.Order_ID) AS total_orders,
    ROUND(SUM(o.Total_Amount), 2) AS total_spent
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name,
    c.City,
    c.Country
ORDER BY total_spent DESC
LIMIT 10;


-- 8. Monthly Revenue
SELECT
    DATE_TRUNC('month', Order_Date)::DATE AS month,
    COUNT(Order_ID) AS total_orders,
    SUM(Quantity) AS books_sold,
    ROUND(SUM(Total_Amount), 2) AS revenue
FROM Orders
GROUP BY month
ORDER BY month;


-- 9. Low Stock Books
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Stock,
    Price
FROM Books
WHERE Stock < 10
ORDER BY Stock ASC;