# Automated Sales Reporting System

*Project Documentation | Excel Power Query • MySQL • Power BI*

## 1. Executive Summary

This project demonstrates a refreshable weekly sales reporting workflow built with synthetic sales data. Weekly CSV files are placed in a designated production input folder, combined and typed in Power Query, validated using Excel and MySQL, and presented in a Power BI management dashboard.

The workflow reduces repetitive manual copying, cleaning, and formatting. A separate eight-row test-week file was temporarily added to the production input folder, and the user confirmed that the Power BI folder refresh worked. The test file was subsequently removed from the production input folder and is kept separate from the production data in the project package.

## 2. Business Requirements

- **Reporting cadence:** Weekly.
- **Audience:** Management.
- **Source delivery:** A folder containing weekly CSV files.
- **Primary pain point:** Manual copying, cleaning, and formatting.
- **Expected outcome:** Consistent KPI reporting, repeatable folder-based ingestion, data-quality checks, and a refreshable Power BI report.

## 3. Tools and Responsibilities

- **Excel Power Query:** Combine CSV files from a folder, standardize data types, and perform initial reconciliation.
- **MySQL:** Store the combined sales data, validate row counts and business rules, calculate KPIs, and expose reusable reporting views.
- **Power BI:** Connect directly to the folder of weekly CSV files, calculate KPI measures with DAX, and visualize performance.

## 4. Data and File Structure

Each CSV row represents one sales order line. The production pack contains **12 weekly CSV files and 933 rows**.

**Columns:** `OrderID`, `OrderDate`, `Region`, `SalesRep`, `Product`, `Category`, `Units`, `UnitPrice`, `DiscountPct`, `NetSales`, `UnitCost`, and `TotalCost`. The combined query also retains `Source.Name` for traceability.

Data is synthetic and intended for portfolio demonstration. The separate QA exception file is deliberately flawed and must not be mixed into the production input folder.

## 5. Power Query Workflow

- **Excel:** Use **Data > Get Data > From File > From Folder**, select the designated production input folder, combine the files, review the sample-file transformation, and load the result to the `Sales_Data` worksheet.
- **Power BI:** Use **Home > Transform data > New Source > Folder**, select the designated production input folder, combine files, and select **Close & Apply**. The production CSV pack contains 933 rows; after refresh, check that the combined query reflects the current production files.
- **Data types:** `OrderID` as text; `OrderDate` as date; `Region`, `SalesRep`, `Product`, and `Category` as text; `Units` as whole number; `UnitPrice`, `DiscountPct`, `NetSales`, `UnitCost`, and `TotalCost` as decimal numbers.
- **WeekStartDate:** Derived using the Monday start of the week: `Date.StartOfWeek([OrderDate], Day.Monday)`. This supports a consistent weekly trend axis.
- **Date handling:** An `OrderDate_ISO` field formatted as `yyyy-MM-dd` was used for CSV-to-MySQL import to avoid locale-dependent date parsing.

## 6. Data Validation and Reconciliation

Production CSV control totals:

| Metric | Result |
|---|---:|
| Rows | 933 |
| Distinct OrderIDs | 933 |
| NetSales | 919,447.60 |
| Units | 2,959 |
| TotalCost | 623,580.00 |
| Gross Profit | 295,867.60 |

Gross Profit is calculated as NetSales minus TotalCost. Gross Margin = Gross Profit divided by NetSales.

SQL quality checks returned zero exceptions for missing OrderID/date/region/product and invalid units, prices, discounts, sales, or costs.

**Reconciliation check:** `NetSales = ROUND(Units * UnitPrice * (1 - DiscountPct), 2)`. The production dataset had zero mismatches.

These control totals represent the 12-file production CSV dataset and can be used as the baseline when checking the production refresh.

## 7. MySQL Reporting Layer

**Database:** `automated_sales_reporting`  
**Table:** `weekly_sales`. The table includes `Source_Name` to retain source-file lineage.

Views created and verified:

- `vw_sales_kpis` — overall sales KPIs.
- `vw_weekly_sales` — weekly sales trend.
- `vw_region_category_sales` — sales by region and category.
- `vw_sales_rep_performance` — sales and profitability by sales representative.

Core reporting metrics: net sales, units sold, total cost, gross profit, gross margin, order-line count, and average sales per order line.

## 8. Power BI Dashboard

**Report title:** Weekly Sales Performance Dashboard.

**KPI cards:** Total Net Sales, Gross Profit, Gross Margin %, Units Sold, and Order Lines.

**Visuals:** Weekly net-sales trend, region/category sales, sales representative performance, and gross profit by sales representative.

All visuals were updated to use the folder-based `Weekly_Sales_Files` query, rather than relying on the MySQL reporting views. This allows new weekly CSV files to be included on refresh.

**DAX measures:**

```DAX
Total Net Sales = SUM(Weekly_Sales_Files[NetSales])
```

```DAX
Gross Profit = SUM(Weekly_Sales_Files[NetSales]) - SUM(Weekly_Sales_Files[TotalCost])
```

```DAX
Gross Margin % = DIVIDE([Gross Profit], [Total Net Sales], 0)
```

```DAX
Units Sold = SUM(Weekly_Sales_Files[Units])
```

```DAX
Order Lines = COUNTROWS(Weekly_Sales_Files)
```

Gross Margin % is formatted as a percentage. KPI display units may be abbreviated in cards (for example, K for thousands).

## 9. Refresh Test and Result

A separate synthetic test file, `Weekly_Sales_Test_Week.csv`, was created with **8 new rows and new OrderIDs**. Its expected totals were:

| Metric | Test-week result |
|---|---:|
| NetSales | 5,117.50 |
| Units | 27 |
| TotalCost | 3,431.00 |
| Gross Profit | 1,686.50 |

The test file was temporarily copied into the production input folder and Power BI Refresh was run. The user confirmed the refresh worked.

Expected totals during the test:

| Metric | Expected total during test |
|---|---:|
| Rows | 941 |
| NetSales | 924,565.10 |
| Units | 2,986 |
| TotalCost | 627,011.00 |
| Gross Profit | 297,554.10 |

The test file was subsequently removed from the production input folder. The 12 production CSV files independently reconcile to 933 order lines and NetSales of 919,447.60. After removing a test file, refresh the PBIX and confirm that the report returns to these production control totals before saving the final report.

This test demonstrates **manual/on-demand refresh** from a folder. Scheduled unattended refresh, gateway configuration, and automated email distribution were not tested and are outside the current scope.

## 10. How to Run the Weekly Process

1. Save each new weekly CSV into the designated production input folder using the agreed column names and data types.
2. Keep QA exception files outside the production input folder.
3. Open `Automated_Sales_Reporting.pbix` and select **Refresh**.
4. Review the five KPI cards and weekly trend. Confirm that totals move in line with the new week.
5. If the totals look unexpected, check the source file for duplicate OrderIDs, missing required fields, invalid numeric values, date parsing issues, and the NetSales formula.
6. Save the refreshed PBIX. For a controlled reporting process, retain the source CSVs and record any corrections.

## 11. Known Limitations and Next Improvements

- Refresh is user-triggered; scheduled refresh and distribution are not configured.
- The current synthetic dataset is designed to demonstrate a workflow rather than represent a real company.
- Recommended next steps: add a formal refresh timestamp, create a dedicated QA summary table, define an exception-handling policy, and publish through Power BI Service only if the required organizational access and gateway/data-source setup are available.

## 12. Project Deliverables

- Twelve weekly production CSV files.
- Separate QA exception dataset for negative testing; not part of the production data.
- Excel workbook with the combined `Sales_Data` query and reconciliation checks.
- MySQL SQL script, `weekly_sales` table, and four reporting views.
- Power BI report: `Automated_Sales_Reporting.pbix`.
- Separate eight-row test-week CSV used for the folder-refresh demonstration.
- Project documentation and companion README.
