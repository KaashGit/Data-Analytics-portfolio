CREATE DATABASE automated_sales_reporting;
USE automated_sales_reporting;
CREATE TABLE weekly_sales (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE,
    Region VARCHAR(30),
    SalesRep VARCHAR(100),
    Product VARCHAR(100),
    Category VARCHAR(50),
    Units INT,
    UnitPrice DECIMAL(10,2),
    DiscountPct DECIMAL(5,2),
    NetSales DECIMAL(12,2),
    UnitCost DECIMAL(10,2),
    TotalCost DECIMAL(12,2),
    Source_Name VARCHAR(255)
);
SELECT 
	COUNT(*) AS row_count,
    COUNT(DISTINCT OrderID) AS unique_order_ids,
    SUM(NetSales) AS total_net_sales,
    SUM(Units) AS total_units,
    SUM(TotalCost) AS total_cost,
    SUM(NetSales)-SUM(TotalCost) AS gross_profit
FROM weekly_sales;

-- Data Quality Check
SELECT
    SUM(OrderID IS NULL OR TRIM(OrderID) = '') AS missing_order_ids,
    SUM(OrderDate IS NULL) AS missing_dates,
    SUM(Region IS NULL OR TRIM(Region) = '') AS missing_regions,
    SUM(Product IS NULL OR TRIM(Product) = '') AS missing_products,
    SUM(Units IS NULL OR Units <= 0) AS invalid_units,
    SUM(UnitPrice IS NULL OR UnitPrice < 0) AS invalid_unit_prices,
    SUM(DiscountPct IS NULL OR DiscountPct < 0 OR DiscountPct > 1)
        AS invalid_discounts,
    SUM(NetSales IS NULL OR NetSales < 0) AS invalid_net_sales,
    SUM(UnitCost IS NULL OR UnitCost < 0) AS invalid_unit_costs,
    SUM(TotalCost IS NULL OR TotalCost < 0) AS invalid_total_costs
FROM weekly_sales;

-- KPIs
SELECT
    COUNT(*) AS total_orders,
    SUM(Units) AS units_sold,
    ROUND(SUM(NetSales), 2) AS total_net_sales,
    ROUND(SUM(TotalCost), 2) AS total_cost,
    ROUND(SUM(NetSales) - SUM(TotalCost), 2) AS gross_profit,
    ROUND(
        100.0 * (SUM(NetSales) - SUM(TotalCost))
        / NULLIF(SUM(NetSales), 0),
        2
    ) AS gross_margin_pct,
    ROUND(AVG(NetSales), 2) AS average_order_value
FROM weekly_sales;

-- Weekly Sales Trend
SELECT
    YEAR(OrderDate) AS sales_year,
    WEEK(OrderDate, 3) AS sales_week,
    MIN(OrderDate) AS week_start_date,
    ROUND(SUM(NetSales), 2) AS weekly_net_sales,
    ROUND(SUM(TotalCost), 2) AS weekly_cost,
    ROUND(SUM(NetSales) - SUM(TotalCost), 2) AS weekly_gross_profit,
    COUNT(*) AS order_lines,
    SUM(Units) AS units_sold
FROM weekly_sales
GROUP BY
    YEAR(OrderDate),
    WEEK(OrderDate, 3)
ORDER BY
    sales_year,
    sales_week;

-- Regional and Category Performance
SELECT
    Region,
    Category,
    COUNT(*) AS order_lines,
    SUM(Units) AS units_sold,
    ROUND(SUM(NetSales), 2) AS net_sales,
    ROUND(SUM(TotalCost), 2) AS total_cost,
    ROUND(SUM(NetSales) - SUM(TotalCost), 2) AS gross_profit,
    ROUND(
        100.0 * (SUM(NetSales) - SUM(TotalCost))
        / NULLIF(SUM(NetSales), 0),
        2
    ) AS gross_margin_pct
FROM weekly_sales
GROUP BY Region, Category
ORDER BY net_sales DESC;

-- By Sales Representative 
SELECT
    SalesRep,
    COUNT(*) AS order_lines,
    SUM(Units) AS units_sold,
    ROUND(SUM(NetSales), 2) AS net_sales,
    ROUND(SUM(NetSales) - SUM(TotalCost), 2) AS gross_profit,
    ROUND(
        100.0 * (SUM(NetSales) - SUM(TotalCost))
        / NULLIF(SUM(NetSales), 0),
        2
    ) AS gross_margin_pct
FROM weekly_sales
GROUP BY SalesRep
ORDER BY net_sales DESC;

-- NetSales Validation
SELECT
    COUNT(*) AS total_rows,
    SUM(
        ABS(
            NetSales -
            ROUND(Units * UnitPrice * (1 - DiscountPct), 2)
        ) > 0.01
    ) AS sales_calculation_mismatches
FROM weekly_sales;

-- KPIs view
CREATE OR REPLACE VIEW vw_sales_kpis AS
SELECT
    COUNT(*) AS total_order_lines,
    SUM(Units) AS total_units_sold,
    ROUND(SUM(NetSales), 2) AS total_net_sales,
    ROUND(SUM(TotalCost), 2) AS total_cost,
    ROUND(SUM(NetSales) - SUM(TotalCost), 2) AS gross_profit,
    ROUND(
        100.0 * (SUM(NetSales) - SUM(TotalCost))
        / NULLIF(SUM(NetSales), 0),
        2
    ) AS gross_margin_pct,
    ROUND(AVG(NetSales), 2) AS avg_sales_per_order_line
FROM weekly_sales;

SELECT * FROM vw_sales_kpis;

-- Sales view
CREATE OR REPLACE VIEW vw_weekly_sales AS
SELECT
    YEAR(OrderDate) AS sales_year,
    WEEK(OrderDate, 3) AS sales_week,
    MIN(OrderDate) AS first_order_date,
    MAX(OrderDate) AS last_order_date,
    COUNT(*) AS order_lines,
    SUM(Units) AS units_sold,
    ROUND(SUM(NetSales), 2) AS net_sales,
    ROUND(SUM(TotalCost), 2) AS total_cost,
    ROUND(SUM(NetSales) - SUM(TotalCost), 2) AS gross_profit
FROM weekly_sales
GROUP BY
    YEAR(OrderDate),
    WEEK(OrderDate, 3);
    
SELECT *
FROM vw_weekly_sales
ORDER BY sales_year, sales_week;

-- Regional & Category sales view
CREATE OR REPLACE VIEW vw_region_category_sales AS
SELECT
    Region,
    Category,
    COUNT(*) AS order_lines,
    SUM(Units) AS units_sold,
    ROUND(SUM(NetSales), 2) AS net_sales,
    ROUND(SUM(TotalCost), 2) AS total_cost,
    ROUND(SUM(NetSales) - SUM(TotalCost), 2) AS gross_profit,
    ROUND(
        100.0 * (SUM(NetSales) - SUM(TotalCost))
        / NULLIF(SUM(NetSales), 0),
        2
    ) AS gross_margin_pct
FROM weekly_sales
GROUP BY Region, Category;

SELECT *
FROM vw_region_category_sales
ORDER BY net_sales DESC;

-- Sales Representative View
CREATE OR REPLACE VIEW vw_sales_rep_performance AS
SELECT
    SalesRep,
    COUNT(*) AS order_lines,
    SUM(Units) AS units_sold,
    ROUND(SUM(NetSales), 2) AS net_sales,
    ROUND(SUM(TotalCost), 2) AS total_cost,
    ROUND(SUM(NetSales) - SUM(TotalCost), 2) AS gross_profit,
    ROUND(
        100.0 * (SUM(NetSales) - SUM(TotalCost))
        / NULLIF(SUM(NetSales), 0),
        2
    ) AS gross_margin_pct
FROM weekly_sales
GROUP BY SalesRep;

SELECT *
FROM vw_sales_rep_performance
ORDER BY net_sales DESC;