USE customer_churn_analysis;
# To check duplicate customer ids
SELECT COUNT(*) AS total_rows, COUNT(DISTINCT customerID) AS unique_customers FROM telco_customers;

# To identify null values
SELECT 
	SUM(customerID IS NULL OR TRIM(customerID)='') AS missing_customer_ids, 
	SUM(Churn IS NULL OR TRIM(Churn)='') AS missing_churn, 
    SUM(MonthlyCharges IS NULL OR TRIM(MonthlyCharges)='') AS missing_monthly_charges, 
    SUM(TotalCharges IS NULL OR TRIM(TotalCharges)='') AS missing_total_charges
FROM telco_customers;

# Minimum, Maximum and Zero-tenure customers
SELECT 
	MIN(tenure) AS minimum_tenure,
    MAX(tenure) AS maximum_tenure,
    SUM(tenure = 0) AS zero_tenure_customers
FROM telco_customers;

# Churn by Contract type
SELECT 
	Contract,
    COUNT(*) AS Total_Customers,
    SUM(Churn ='Yes') AS Churned_Customers,
    ROUND(100.0*SUM(Churn='Yes')/COUNT(*),2) AS Churn_Rate
FROM telco_customers
GROUP BY Contract
ORDER BY Churn_Rate DESC;

# Churn by Tenure group
SELECT
	CASE 
	   WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
       WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
       WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
       WHEN tenure BETWEEN 49 AND 72 THEN '49-72 Months'
	END AS Tenure_Group,
    COUNT(*) AS Total_Customers,
    SUM(Churn ='Yes') AS Churned_Customers,
    ROUND(100.0*SUM(Churn='Yes')/COUNT(*),2) AS Churn_Rate
FROM telco_customers
GROUP BY 
	CASE 
	   WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
       WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
       WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
       WHEN tenure BETWEEN 49 AND 72 THEN '49-72 Months'
	END
ORDER BY MIN(tenure);

# Churn by Internet Service
SELECT 
	InternetService,
    COUNT(*) AS Total_Customers,
    SUM(Churn ='Yes') AS Churned_Customers,
    ROUND(100.0*SUM(Churn='Yes')/COUNT(*),2) AS Churn_Rate
FROM telco_customers
GROUP BY InternetService
ORDER BY Churn_Rate DESC;

# Churn by Payment Method
SELECT 
	PaymentMethod,
    COUNT(*) AS Total_Customers,
    SUM(Churn ='Yes') AS Churned_Customers,
    ROUND(100.0*SUM(Churn='Yes')/COUNT(*),2) AS Churn_Rate
FROM telco_customers
GROUP BY PaymentMethod
ORDER BY Churn_Rate DESC;

# Average monthly charges by churn
SELECT
    Churn,
    COUNT(*) AS Customer_Count,
    ROUND(AVG(MonthlyCharges), 2) AS Avg_Monthly_Charges,
    ROUND(MIN(MonthlyCharges), 2) AS Min_Monthly_Charges,
    ROUND(MAX(MonthlyCharges), 2) AS Max_Monthly_Charges
FROM telco_customers
GROUP BY Churn;

# Churn by monthly charge band
SELECT
    CASE
        WHEN MonthlyCharges < 35 THEN 'Under 35'
        WHEN MonthlyCharges < 70 THEN '35-69.99'
        WHEN MonthlyCharges < 100 THEN '70-99.99'
        ELSE '100+'
    END AS Monthly_Charge_Band,
    COUNT(*) AS Total_Customers,
    SUM(Churn = 'Yes') AS Churned_Customers,
    ROUND(
        100.0 * SUM(Churn = 'Yes') / COUNT(*),
        2
    ) AS Churn_Rate
FROM telco_customers
GROUP BY Monthly_Charge_Band
ORDER BY MIN(MonthlyCharges);

# Churn by tenure and contract 
SELECT
    Contract,
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 Months'
    END AS Tenure_Group,
    COUNT(*) AS Total_Customers,
    SUM(Churn = 'Yes') AS Churned_Customers,
    ROUND(
        100.0 * SUM(Churn = 'Yes') / COUNT(*),
        2
    ) AS Churn_Rate
FROM telco_customers
GROUP BY
    Contract,
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
        WHEN tenure BETWEEN 49 AND 72 THEN '49-72 Months'
    END
ORDER BY Contract, MIN(tenure);

# Null Values
SELECT
    COUNT(*) AS Total_Customers,
    SUM(tenure = 0) AS Zero_Tenure_Customers,
    SUM(TotalCharges IS NULL) AS Null_TotalCharges,
    SUM(TRIM(TotalCharges) = '') AS Blank_TotalCharges
FROM telco_customers;


SELECT 
	customerID, tenure, MonthlyCharges, TotalCharges, Churn
FROM telco_customers
WHERE tenure=0
  OR TRIM(TotalCharges)='';
  
  CREATE OR REPLACE VIEW vw_customer_churn AS
	SELECT
        `customer_churn_analysis`.`telco_customers`.`customerID` AS `customerID`,
        `customer_churn_analysis`.`telco_customers`.`gender` AS `gender`,
        `customer_churn_analysis`.`telco_customers`.`SeniorCitizen` AS `SeniorCitizen`,
        `customer_churn_analysis`.`telco_customers`.`Partner` AS `Partner`,
        `customer_churn_analysis`.`telco_customers`.`Dependents` AS `Dependents`,
        `customer_churn_analysis`.`telco_customers`.`tenure` AS `tenure`,
        `customer_churn_analysis`.`telco_customers`.`PhoneService` AS `PhoneService`,
        `customer_churn_analysis`.`telco_customers`.`MultipleLines` AS `MultipleLines`,
        `customer_churn_analysis`.`telco_customers`.`InternetService` AS `InternetService`,
        `customer_churn_analysis`.`telco_customers`.`OnlineSecurity` AS `OnlineSecurity`,
        `customer_churn_analysis`.`telco_customers`.`OnlineBackup` AS `OnlineBackup`,
        `customer_churn_analysis`.`telco_customers`.`DeviceProtection` AS `DeviceProtection`,
        `customer_churn_analysis`.`telco_customers`.`TechSupport` AS `TechSupport`,
        `customer_churn_analysis`.`telco_customers`.`StreamingTV` AS `StreamingTV`,
        `customer_churn_analysis`.`telco_customers`.`StreamingMovies` AS `StreamingMovies`,
        `customer_churn_analysis`.`telco_customers`.`Contract` AS `Contract`,
        `customer_churn_analysis`.`telco_customers`.`PaperlessBilling` AS `PaperlessBilling`,
        `customer_churn_analysis`.`telco_customers`.`PaymentMethod` AS `PaymentMethod`,
        `customer_churn_analysis`.`telco_customers`.`MonthlyCharges` AS `MonthlyCharges`,
        CAST(NULLIF(TRIM(`customer_churn_analysis`.`telco_customers`.`TotalCharges`),
                    '')
            AS DECIMAL (10 , 2 )) AS `TotalCharges`,
        `customer_churn_analysis`.`telco_customers`.`Churn` AS `Churn`
    FROM
        `customer_churn_analysis`.`telco_customers`;
  
  SELECT
    COUNT(*) AS Total_Customers,
    COUNT(DISTINCT customerID) AS Unique_Customers,
    SUM(Churn = 'Yes') AS Churned_Customers,
    SUM(Churn = 'No') AS Retained_Customers,
    SUM(TotalCharges IS NULL) AS Missing_TotalCharges
FROM customer_churn_analysis.vw_customer_churn;