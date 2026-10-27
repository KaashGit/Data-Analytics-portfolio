# Automated Sales Reporting System

## Overview
Built a repeatable weekly sales reporting workflow using synthetic weekly CSV files, Excel Power Query, MySQL, and Power BI.

## Business problem
Manual copying, cleaning, and formatting of weekly sales reports is repetitive and makes consistent validation harder.

## Workflow
1. Combined weekly CSV files from a designated folder.
2. Standardized data types and handled date formatting for SQL import.
3. Loaded combined data into MySQL and checked row counts, unique order IDs, business rules, and sales formula reconciliation.
4. Created reusable SQL views for KPIs, weekly sales, region/category performance, and sales-representative performance.
5. Built a Power BI dashboard with KPI cards and sales performance visuals.
6. Tested folder-based refresh with a separate synthetic test-week file, then removed it to restore the production baseline.

## Tools
Excel Power Query, MySQL/SQL, Power BI, DAX.

## Production validation baseline
- Weekly CSV files: 12
- Rows / unique order IDs: 933 / 933
- Net sales: 919,447.60
- Units: 2,959
- Total cost: 623,580.00
- Gross profit: 295,867.60
- Gross margin: 32.18%
- Average sales per order line: 985.47

## SQL views
- `vw_sales_kpis`
- `vw_weekly_sales`
- `vw_region_category_sales`
- `vw_sales_rep_performance`

## DAX measures
```DAX
Total Net Sales = SUM(Weekly_Sales_Files[NetSales])
Gross Profit = SUM(Weekly_Sales_Files[NetSales]) - SUM(Weekly_Sales_Files[TotalCost])
Gross Margin % = DIVIDE([Gross Profit], [Total Net Sales], 0)
Units Sold = SUM(Weekly_Sales_Files[Units])
Order Lines = COUNTROWS(Weekly_Sales_Files)
```

## Refresh test and scope
A new synthetic test file with 8 rows was successfully included through a manual Power BI refresh. This demonstrates refresh-on-demand from a folder. Scheduled unattended refresh and automated email delivery were not implemented.

## Deliverables
Add final SQL script, Excel workbook, Power BI `.pbix`, dashboard screenshot, and project documentation.

## Data note
All sales records are synthetic and created for portfolio demonstration.
