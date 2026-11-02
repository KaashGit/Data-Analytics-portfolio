# Sales Analytics Dashboard \| Excel & MySQL

## 1. Project Overview

This project analyses sales performance using the Sample Superstore
dataset obtained from Kaggle. It combines MySQL and Microsoft Excel to
explore sales, profit, customer segments, product performance, regional
performance, discounts, returns, and monthly sales trends.

The project demonstrates how SQL-based analysis and data validation can
be combined with an interactive Excel dashboard to generate business
insights and support data-driven decision-making.

## 2. Business Objectives

-   Evaluate overall sales, profit, and profitability.
-   Identify high-performing products and product categories.
-   Compare sales performance across regions and customer segments.
-   Examine the relationship between discounts and profit.
-   Analyse returned orders across customer segments.
-   Understand monthly sales performance over time.
-   Present key business metrics through an interactive dashboard.

## 3. Tools and Technologies

-   **MySQL:** Data exploration, SQL queries, joins, aggregations, and
    validation.
-   **Microsoft Excel:** Data analysis, PivotTables, formulas, and
    dashboard development.
-   **Excel Slicers:** Interactive filtering by region, customer
    segment, and product category.

## 4. Dataset Overview

**Dataset:** Sample Superstore\
**Source:** Kaggle

The dataset is organised into five tables:

  Table                           Records
  --------------- -----------------------
  Customers                           793
  Products                          1,894
  Employees         Available in database
  Orders                            5,009
  Order Details                     9,994

The data was used to analyse customer, product, order, and sales
transaction information.

## 5. SQL Analysis

Ten analytical queries were developed:

1.  Overall sales, total profit, and profit margin.
2.  Sales and profitability by region.
3.  Top 10 products by sales.
4.  Top 10 products by profit and profit margin.
5.  Sales by customer segment.
6.  Most profitable product categories.
7.  Discount versus average profit.
8.  Top 10 customers by sales.
9.  Returned orders by customer segment.
10. Monthly sales trends.

Additional SQL validation checks examined missing references, duplicate
records, invalid values, and date inconsistencies.

## 6. Excel Dashboard

### Key Performance Indicators

  KPI                         Result
  ----------------- ----------------
  Total Sales         \$2,297,200.86
  Total Profit          \$286,397.02
  Profit Margin               12.47%
  Returned Orders                296

### Dashboard Visualisations

-   Monthly Sales Trend (2014--2017)
-   Sales by Region
-   Profit by Category
-   Sales by Customer Segment
-   Discount versus Average Profit
-   Top 10 Products by Sales
-   Top 10 Products by Profit
-   Returned Orders by Customer Segment

### Interactive Filters

-   Region
-   Customer Segment
-   Product Category

The slicers allow users to explore business performance across different
dimensions.

## 7. Key Business Findings

-   Total sales reached approximately **\$2.30 million**, with total
    profit of approximately **\$286.40K**.
-   The overall profit margin was **12.47%**.
-   Regional and customer-segment analysis provides insights into
    differences in sales performance.
-   Product-level analysis identifies top-performing products by sales
    and profit.
-   Category-level analysis compares profitability across product
    categories.
-   Discount analysis examines how average profit varies across discount
    levels.
-   The analysis identified **296 distinct returned orders**, compared
    with 800 returned order-detail records.

## 8. Data Validation

SQL validation checks confirmed:

-   793 customer records.
-   1,894 product records.
-   5,009 order records.
-   9,994 order-detail records.
-   No orphaned order-detail records.
-   No orders with missing customer references.
-   No order details with missing product references.
-   No duplicate key or ID issues in the checks performed.
-   No invalid order-detail values in the checks performed.
-   No shipping dates earlier than order dates in the checks performed.

## 9. Project Deliverables

The repository contains:

-   `Sales_Analytics_Project.sql` -- SQL analysis and validation
    queries.
-   `Sales_Analytics_Dashboard.xlsx` -- Interactive Excel dashboard.
-   `Datasets/` -- Source dataset CSV files.
-   Dashboard screenshot.
-   `README.md` -- Project documentation.

## 10. Conclusion

This project demonstrates how MySQL and Excel can be combined to perform
business-oriented data analysis.

MySQL was used to explore, analyse, and validate the data, while Excel
was used to create analytical summaries and an interactive dashboard.

The final dashboard provides an overview of sales, profitability,
product performance, customer segments, regional performance, and
returned orders.

The project demonstrates practical skills in SQL querying, data
validation, Excel analysis, dashboard development, and communicating
business insights.
