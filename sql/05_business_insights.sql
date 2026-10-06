-- =========================================
-- BUSINESS INSIGHTS & KEY METRICS
-- =========================================


-- 1. Overall Business KPIs
SELECT
    COUNT(DISTINCT Order_ID) AS total_orders,
    SUM(Quantity) AS total_books_sold,
    ROUND(SUM(Total_Amount), 2) AS total_revenue,
    ROUND(AVG(Total_Amount), 2) AS average_order_value
FROM Orders;


-- 2. Top Revenue-Generating Genre
SELECT
    b.Genre,
    ROUND(SUM(o.Total_Amount), 2) AS revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY revenue DESC
LIMIT 1;


-- 3. Top-Selling Book
SELECT
    b.Title,
    b.Author,
    SUM(o.Quantity) AS units_sold,
    ROUND(SUM(o.Total_Amount), 2) AS revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author
ORDER BY units_sold DESC
LIMIT 1;


-- 4. Highest-Spending Customer
SELECT
    c.Customer_ID,
    c.Name,
    ROUND(SUM(o.Total_Amount), 2) AS total_spent
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY total_spent DESC
LIMIT 1;


-- 5. Total Inventory Value
SELECT
    ROUND(SUM(Price * Stock), 2) AS total_inventory_value
FROM Books;


-- 6. Low Stock Books Count
SELECT
    COUNT(*) AS low_stock_books
FROM Books
WHERE Stock < 10;


-- 7. Repeat Customer Count
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT Customer_ID
    FROM Orders
    GROUP BY Customer_ID
    HAVING COUNT(Order_ID) > 1
) AS repeat_customer_list;


-- 8. Revenue by Country
SELECT
    c.Country,
    ROUND(SUM(o.Total_Amount), 2) AS revenue
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Country
ORDER BY revenue DESC;


-- 9. Revenue by City
SELECT
    c.City,
    ROUND(SUM(o.Total_Amount), 2) AS revenue
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.City
ORDER BY revenue DESC
LIMIT 10;


-- 10. Books With No Sales
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Stock
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL
ORDER BY b.Stock DESC;