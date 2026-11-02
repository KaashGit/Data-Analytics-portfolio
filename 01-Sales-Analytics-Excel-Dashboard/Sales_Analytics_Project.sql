USE sales_analytics;

-- 1. Customers
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(30)
);


-- 2. Products
CREATE TABLE products (
    product_id VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(200),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);


-- 3. Employees / Regional Managers
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    region VARCHAR(30)
);


-- 4. Orders
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    employee_id INT,
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);


-- 5. Order Details
CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(20),
    product_id VARCHAR(30),
    quantity INT,
    sales DECIMAL(12,2),
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

USE sales_analytics;

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    region VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(20),
    product_id VARCHAR(30),
    quantity INT,
    sales DECIMAL(12,2),
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

USE sales_analytics;

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(30)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(20),
    product_id VARCHAR(30),
    quantity INT,
    sales DECIMAL(12,2),
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

USE sales_analytics;

CREATE TABLE products (
    product_key INT PRIMARY KEY AUTO_INCREMENT,
    product_id VARCHAR(30),
    product_name VARCHAR(200),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(30),
    returned VARCHAR(5),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(20),
    product_key INT,
    quantity INT,
    sales DECIMAL(12,2),
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_key)
        REFERENCES products(product_key)
);

SELECT *
FROM customers
LIMIT 5;


SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details;

SELECT COUNT(*) AS orphan_order_details
FROM order_details od
LEFT JOIN orders o
    ON od.order_id = o.order_id
WHERE o.order_id IS NULL;

USE sales_analytics;

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin_pct
FROM order_details;


SELECT 
    'customers' AS table_name, COUNT(*) AS row_count
FROM
    customers 
UNION ALL SELECT 
    'products', COUNT(*)
FROM
    products 
UNION ALL SELECT 
    'employees', COUNT(*)
FROM
    employees 
UNION ALL SELECT 
    'orders', COUNT(*)
FROM
    orders 
UNION ALL SELECT 
    'order_details', COUNT(*)
FROM
    order_details;

# QUERY 1 for total sales, total Profit and profit percentage

SELECT 
    ROUND(SUM(sales), 2) AS Total_Sales,
    ROUND(SUM(profit), 2) AS Total_Profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS Profit_margin_Pct
FROM
    order_details;
    
# QUERY 2 Sales By Region

SELECT
	Region, ROUND(SUM(sales), 2) AS Total_Sales, 
    ROUND(SUM(profit), 2) AS Total_Profit, 
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS Profit_margin_Pct
FROM orders
JOIN order_details
	ON order_details.order_id = orders.order_id
GROUP BY region;

#Query 3 TOP 10 Products by Sales

SELECT
	products.Product_key, Product_name, SUM(sales) AS Total_Sales
FROM products
JOIN order_details
	ON order_details.product_key = products.product_key
GROUP BY products.product_key
ORDER BY Total_Sales DESC
LIMIT 10;

#Query 4 TOP 10 Products by Profit

SELECT
	products.Product_key, Product_name, SUM(profit) AS Total_Profit, ROUND(SUM(profit) / SUM(sales) * 100, 2) AS Profit_margin_Pct
FROM products
JOIN order_details
	ON order_details.product_key = products.product_key
GROUP BY products.product_key
ORDER BY Total_Profit DESC
LIMIT 10;

#Query 5 Sales By Customer Segment

SELECT 
	segment AS Customer_Segment, SUM(sales) AS Total_Sales
FROM order_details AS od
JOIN orders AS o
	ON od.order_id = o.order_id
Join customers AS cust
    ON o.customer_id = cust.customer_id
GROUP BY Customer_Segment;


# Query 6 Most Profitable Categories

SELECT 
	category, SUM(profit) AS Total_Profit
FROM order_details AS od
JOIN products AS p
	ON od.product_key = p.product_key
GROUP BY category
ORDER BY Total_Profit DESC;

# Query 7 Discount VS Profit

SELECT discount, round(avg(profit),2)
FROM order_details
GROUP BY discount 
ORDER BY discount;

# Query 8 Top 10 customers by total sales

SELECT 
	customer_name AS Customers, SUM(sales) AS Total_Sales
FROM order_details AS od
JOIN orders AS o
	ON od.order_id = o.order_id
Join customers AS cust
    ON o.customer_id = cust.customer_id
GROUP BY Customers
ORDER BY Total_Sales DESC
LIMIT 10;

# QUERY 9 Returned Orders by Customers_segment

SELECT count(*) AS Returned_Orders, segment AS Customers_Segment
FROM orders AS o
Join customers AS cust
    ON o.customer_id = cust.customer_id
WHERE returned = "YES"
GROUP BY segment;

# Query 10 Monthly Sales Trends

SELECT
    MONTH(order_date) AS Month_Number,
    MONTHNAME(order_date) AS Sales_Month,
    SUM(sales) AS Total_Sales
FROM order_details AS od
JOIN orders AS o
    ON od.order_id = o.order_id
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY Month_Number;

-- Validation Queries

-- 1. Orders without matching customers
SELECT COUNT(*) AS orphan_customers
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 2. Order details without matching products
SELECT COUNT(*) AS orphan_products
FROM order_details od
LEFT JOIN products p ON od.product_key = p.product_key
WHERE p.product_key IS NULL;

-- 3. Duplicate customer IDs
SELECT COUNT(*) AS duplicate_customer_groups
FROM (
    SELECT customer_id
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) x;

-- 4. Duplicate product keys
SELECT COUNT(*) AS duplicate_product_groups
FROM (
    SELECT product_key
    FROM products
    GROUP BY product_key
    HAVING COUNT(*) > 1
) x;

-- 5. Duplicate order IDs
SELECT COUNT(*) AS duplicate_order_groups
FROM (
    SELECT order_id
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
) x;

-- 6. Duplicate order-detail IDs
SELECT COUNT(*) AS duplicate_detail_groups
FROM (
    SELECT order_detail_id
    FROM order_details
    GROUP BY order_detail_id
    HAVING COUNT(*) > 1
) x;

-- 7. Missing important values in orders
SELECT
    SUM(customer_id IS NULL) AS missing_customer,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(region IS NULL) AS missing_region
FROM orders;

-- 8. Invalid order-detail values
SELECT COUNT(*) AS invalid_order_details
FROM order_details
WHERE quantity <= 0
   OR sales < 0
   OR profit IS NULL
   OR discount < 0
   OR discount > 1;

-- 9. Invalid shipping dates
SELECT COUNT(*) AS invalid_shipping_dates
FROM orders
WHERE ship_date < order_date;