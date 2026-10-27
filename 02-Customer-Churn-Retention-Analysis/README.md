# Customer Churn & Retention Analysis

## Overview
Analyzed the IBM Telco Customer Churn dataset to understand churn patterns and identify segments that may benefit from retention efforts.

## Business objective
Measure churn and retention, compare customer segments, and translate findings into actionable retention recommendations.

## Tools
MySQL, Excel, Power Query, Power BI, DAX.

## Data validation
- 7,043 customer records and distinct customer IDs.
- 1,869 churned customers and 5,174 retained customers.
- Overall churn: 26.54%; retention: 73.46%.
- `TotalCharges` was imported as text and contained 11 blank strings associated with zero-tenure customers. A SQL view converted valid values to decimal and blanks to `NULL`, preserving the source table.

## Key findings
- Month-to-month contracts: 42.71% churn; one-year: 11.27%; two-year: 2.83%.
- Tenure 0–12 months: 47.44% churn; tenure 49–72 months: 9.51%.
- Fiber optic: 41.89% churn; DSL: 18.96%; no internet service: 7.40%.
- Electronic check: 45.29% churn.
- Average monthly charges: 74.44 for churned customers and 61.27 for retained customers.

## Workflow
1. Defined the business question and reviewed the data.
2. Validated records and handled the `TotalCharges` import issue in a SQL view.
3. Explored churn patterns in Excel PivotTables.
4. Used Power Query to check data types, nulls, errors, and create tenure groups.
5. Built a Power BI dashboard with KPI cards, segment charts, and slicers.
6. Documented findings and retention recommendations.

## Deliverables
Add final SQL script, Excel workbook, Power BI `.pbix`, dashboard screenshot, and documentation as appropriate.

## Recommendation themes
Prioritize early-tenure customers, review the month-to-month customer experience, and investigate churn drivers among fiber-optic and electronic-check customers. These are investigation priorities, not proof of causation.

## Data source
IBM Telco Customer Churn dataset. Add the source URL and license/usage notes before publishing.
