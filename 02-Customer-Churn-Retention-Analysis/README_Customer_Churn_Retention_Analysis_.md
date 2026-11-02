# Customer Churn & Retention Analysis

## Overview

This project analyzes customer churn in the IBM Telco Customer Churn dataset using Excel, MySQL, Power Query, Power BI, and DAX. It explores churn patterns across contract type, customer tenure, internet service, payment method, and monthly charge bands.

## Dataset

- **Dataset:** IBM Telco Customer Churn
- **Source:** [Kaggle – Telco Customer Churn](https://www.kaggle.com/blastchar/telco-customer-churn/)
- **Size:** 7,043 customer records and 21 original columns

The dataset includes customer demographics, subscribed services, account information, charges, and a churn indicator.

## Key performance indicators

| KPI | Result |
|---|---:|
| Total customers | 7,043 |
| Churned customers | 1,869 |
| Retained customers | 5,174 |
| Churn rate | **26.54%** |
| Retention rate | **73.46%** |

## Tools and workflow

- **Excel:** Exploratory analysis, PivotTables, and summary tables.
- **MySQL:** Data validation, segmentation queries, and the `vw_customer_churn` view. The view converts valid `TotalCharges` values to a numeric data type and maps blank strings to `NULL`.
- **Power Query:** Data-type and missing-value checks, plus creation of tenure groups.
- **Power BI and DAX:** KPI measures and an interactive dashboard.

## Key findings

- **Contract type:** Month-to-month customers had a churn rate of **42.71%**, compared with **11.27%** for one-year contracts and **2.83%** for two-year contracts.
- **Tenure:** Churn was highest among customers with 0–12 months of tenure (**47.44%**) and declined across the longer-tenure groups.
- **Internet service:** Customers with fiber optic service had a churn rate of **41.89%**.
- **Payment method:** Customers using electronic checks had a churn rate of **45.29%**.
- **Monthly charges:** The 70–99.99 charge band had the highest observed churn rate among the defined bands (**37.91%**).
- **Average monthly charges:** The average was **74.44** for churned customers and **61.27** for retained customers.
- **Combined segment:** Among month-to-month customers with 0–12 months of tenure, **1,024 of 1,994 customers churned (51.35%)**. This combined result was verified using SQL.

These findings describe associations in the dataset and should not be interpreted as evidence of causation.

## Recommendations

- Investigate early-tenure churn through onboarding reviews, early support interactions, and customer feedback.
- Explore why month-to-month customers leave and evaluate suitable contract options.
- Review service experience and support for fiber optic customers.
- Examine the customer journey for electronic-check users.
- Investigate the service and contract mix within the 70–99.99 monthly-charge band before making pricing decisions.
- Evaluate future retention initiatives using controlled experiments or well-designed comparisons.

## Data quality and limitations

- The analysis contains **7,043 rows and 7,043 distinct customer IDs**.
- Eleven blank or null `TotalCharges` values are associated with zero-tenure records. They were retained as missing values rather than automatically replaced with zero.
- Observed associations do not establish causality.
- The dataset does not provide detailed churn reasons, campaign effectiveness, or market-share information.
- Monthly charge bands are exploratory categories created for this analysis.
- Power Query error checking was performed on selected columns, not as an exhaustive audit of every column.

## Project deliverables

- Excel customer churn exploration workbook (`.xlsx`)
- MySQL analysis script (`.sql`), including the `vw_customer_churn` view
- Power BI interactive dashboard (`.pbix`)
- Project documentation (`.docx`)

## Conclusion

The analysis highlights meaningful differences in churn across contract type, tenure, internet service, payment method, and monthly charge bands. Month-to-month customers and customers in their first 12 months stand out as segments for further investigation. The project demonstrates an end-to-end analytics workflow, from exploratory analysis and SQL validation to Power Query transformation, DAX measures, and Power BI reporting.
