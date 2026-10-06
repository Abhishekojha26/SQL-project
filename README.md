# 📚 Online Bookstore Sales & Customer Analytics

## 👨‍💻 Author

**Abhishek Ojha**

Computer Engineering Student | SQL & Data Analytics Enthusiast

---

## 📌 Project Overview

This project analyzes an online bookstore dataset using PostgreSQL to understand sales performance, customer purchasing behavior, book performance, revenue trends, and inventory status.

The project demonstrates SQL skills ranging from basic aggregations and joins to advanced analytical techniques such as CTEs, window functions, `LAG()`, `DENSE_RANK()`, `CASE WHEN`, and `COALESCE()`.

---

## 🎯 Business Objectives

The main objectives of this project are:

- Analyze overall bookstore sales and revenue
- Identify best-selling books and high-performing genres
- Identify high-value and repeat customers
- Analyze monthly revenue trends and growth
- Evaluate inventory levels and identify low-stock books
- Analyze author-level performance
- Identify books with no sales
- Generate actionable business recommendations

---

## 🗂️ Dataset

The project contains three relational datasets.

### 📚 Books

Contains information about books available in the bookstore.

**Key Columns:**

- `Book_ID`
- `Title`
- `Author`
- `Genre`
- `Published_Year`
- `Price`
- `Stock`

### 👤 Customers

Contains customer information.

**Key Columns:**

- `Customer_ID`
- `Name`
- `Email`
- `Phone`
- `City`
- `Country`

### 🛒 Orders

Contains customer transaction information.

**Key Columns:**

- `Order_ID`
- `Customer_ID`
- `Book_ID`
- `Order_Date`
- `Quantity`
- `Total_Amount`

---

## 🛠️ Tools & Technologies

- **Database:** PostgreSQL
- **Database Tool:** pgAdmin 4
- **Language:** SQL
- **Version Control:** Git
- **Repository:** GitHub

---

## 🔗 Database Relationships

```text
Customers
    |
    | Customer_ID
    ↓
  Orders
    |
    | Book_ID
    ↓
   Books