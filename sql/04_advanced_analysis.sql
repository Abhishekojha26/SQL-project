-- =========================================
-- ADVANCED SQL ANALYSIS
-- =========================================


-- 1. Customer Segmentation
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS total_orders,
    ROUND(SUM(o.Total_Amount), 2) AS total_spent,
    CASE
        WHEN SUM(o.Total_Amount) >= 300 THEN 'High Value'
        WHEN SUM(o.Total_Amount) >= 150 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY total_spent DESC;


-- 2. Genre-wise Book Ranking using DENSE_RANK
WITH BookSales AS (
    SELECT
        b.Book_ID,
        b.Title,
        b.Author,
        b.Genre,
        SUM(o.Quantity) AS units_sold,
        SUM(o.Total_Amount) AS revenue
    FROM Books b
    JOIN Orders o
        ON b.Book_ID = o.Book_ID
    GROUP BY
        b.Book_ID,
        b.Title,
        b.Author,
        b.Genre
)

SELECT
    Title,
    Author,
    Genre,
    units_sold,
    ROUND(revenue, 2) AS revenue,
    DENSE_RANK() OVER (
        PARTITION BY Genre
        ORDER BY units_sold DESC
    ) AS genre_rank
FROM BookSales
ORDER BY Genre, genre_rank;


-- 3. Revenue Contribution by Genre
WITH GenreSales AS (
    SELECT
        b.Genre,
        SUM(o.Total_Amount) AS revenue
    FROM Books b
    JOIN Orders o
        ON b.Book_ID = o.Book_ID
    GROUP BY b.Genre
)

SELECT
    Genre,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        revenue * 100.0 / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM GenreSales
ORDER BY revenue DESC;


-- 4. Monthly Running Revenue
WITH MonthlySales AS (
    SELECT
        DATE_TRUNC('month', Order_Date)::DATE AS month,
        SUM(Total_Amount) AS monthly_revenue
    FROM Orders
    GROUP BY month
)

SELECT
    month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_revenue
FROM MonthlySales
ORDER BY month;


-- 5. Month-over-Month Revenue Growth
WITH MonthlySales AS (
    SELECT
        DATE_TRUNC('month', Order_Date)::DATE AS month,
        SUM(Total_Amount) AS monthly_revenue
    FROM Orders
    GROUP BY month
),

PreviousMonth AS (
    SELECT
        month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM MonthlySales
)

SELECT
    month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (monthly_revenue - previous_month_revenue)
        * 100.0 / NULLIF(previous_month_revenue, 0),
        2
    ) AS mom_growth_percentage
FROM PreviousMonth
ORDER BY month;


-- 6. Repeat Customers
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS total_orders,
    ROUND(SUM(o.Total_Amount), 2) AS total_spent
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(o.Order_ID) > 1
ORDER BY total_orders DESC, total_spent DESC;


-- 7. Customer Lifetime Value / Ranking
WITH CustomerStats AS (
    SELECT
        c.Customer_ID,
        c.Name,
        COUNT(o.Order_ID) AS total_orders,
        SUM(o.Quantity) AS books_purchased,
        SUM(o.Total_Amount) AS total_spent
    FROM Customers c
    JOIN Orders o
        ON c.Customer_ID = o.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Name
)

SELECT
    Customer_ID,
    Name,
    total_orders,
    books_purchased,
    ROUND(total_spent, 2) AS total_spent,
    ROUND(total_spent / total_orders, 2) AS avg_order_value,
    DENSE_RANK() OVER (
        ORDER BY total_spent DESC
    ) AS customer_rank
FROM CustomerStats
ORDER BY customer_rank;


-- 8. Author Performance
SELECT
    b.Author,
    COUNT(DISTINCT b.Book_ID) AS total_books,
    SUM(o.Quantity) AS units_sold,
    ROUND(SUM(o.Total_Amount), 2) AS revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY revenue DESC
LIMIT 10;


-- 9. Book Performance and Inventory Status
WITH BookPerformance AS (
    SELECT
        b.Book_ID,
        b.Title,
        b.Author,
        b.Genre,
        b.Stock,
        COALESCE(SUM(o.Quantity), 0) AS units_sold,
        COALESCE(SUM(o.Total_Amount), 0) AS revenue
    FROM Books b
    LEFT JOIN Orders o
        ON b.Book_ID = o.Book_ID
    GROUP BY
        b.Book_ID,
        b.Title,
        b.Author,
        b.Genre,
        b.Stock
)

SELECT
    Title,
    Author,
    Genre,
    Stock,
    units_sold,
    ROUND(revenue, 2) AS revenue,
    CASE
        WHEN units_sold = 0 AND Stock > 0
            THEN 'No Sales - Review Required'
        WHEN Stock < 10 AND units_sold > 0
            THEN 'High Demand - Restock'
        WHEN Stock >= 10 AND units_sold >= 5
            THEN 'Good Performance'
        ELSE 'Normal'
    END AS performance_status
FROM BookPerformance
ORDER BY revenue DESC;