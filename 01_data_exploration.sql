-- ===============================================================================================================
-- Project:     Customer Segmentation & Behavioral Analysis
-- File:        01_data_exploration.sql
-- Purpose:     Investigate the original dataset, identify anomalies, and validate data quality.
-- ===============================================================================================================

-- ---------------------------------------------------------------------------------------------------------------
-- 1. Data Loading and Schema Validation
-- ---------------------------------------------------------------------------------------------------------------

-- Load InvoiceDate as VARCHAR to prevent automatic date parsing errors caused by inconsistent source formatting.
CREATE OR REPLACE VIEW raw_data AS
SELECT * 
FROM read_csv('data/online_retail.csv', types={'InvoiceDate': 'VARCHAR'});

-- Inspect the first ten rows of raw data.
SELECT * FROM raw_data LIMIT 10;

-- Check the total number of rows imported.
SELECT COUNT(*) AS row_count FROM raw_data;  

-- Verify the imported column data types.
DESCRIBE raw_data;

-- ---------------------------------------------------------------------------------------------------------------
-- 2. Missing Values 
-- ---------------------------------------------------------------------------------------------------------------

-- Check the total number of nulls for each column.
SELECT
    COUNT(*) AS total_rows,
    total_rows - COUNT(InvoiceNo) AS InvoiceNo_null,
    total_rows - COUNT(StockCode) AS StockCode_null,
    total_rows - COUNT(Description) AS Description_null,
    total_rows - COUNT(Quantity) AS Quantity_null,
    total_rows - COUNT(InvoiceDate) AS InvoiceDate_null,
    total_rows - COUNT(UnitPrice) AS UnitPrice_null,
    total_rows - COUNT(CustomerID) AS CustomerID_null,
    total_rows - COUNT(Country) AS Country_null
FROM raw_data;

-- ---------------------------------------------------------------------------------------------------------------
-- 3. Duplicate Rows
-- ---------------------------------------------------------------------------------------------------------------
-- Sum total number of excess exact row duplicates and find monetary impact of removing them.
WITH duplicates AS (
    SELECT *,
        COUNT(*) - 1 AS num_excess_duplicates
    FROM raw_data
    GROUP BY ALL
    HAVING COUNT(*) > 1
    )
SELECT SUM(num_excess_duplicates) AS total_excess_duplicates,
    SUM(Quantity * UnitPrice * num_excess_duplicates) AS net_monetary_impact,
    SUM(ABS(Quantity) * UnitPrice * num_excess_duplicates) AS absolute_monetary_impact
FROM duplicates;

-- Investigate exact row duplicates.
SELECT *
FROM raw_data
GROUP BY ALL
HAVING COUNT(*) > 1;

-- ---------------------------------------------------------------------------------------------------------------
-- 4. InvoiceNo Validation
-- ---------------------------------------------------------------------------------------------------------------
-- Investigate InvoiceNo format deviations from 6 digits or 6 digits with a leading 'C'.
SELECT *
FROM raw_data
WHERE NOT (
    REGEXP_MATCHES(InvoiceNo, '^[0-9]{6}$')
    OR REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$'));

-- Investigate rows with matching InvoiceNo.
SELECT InvoiceNo,
    LIST(StockCode) AS stock_code_list 
FROM raw_data
GROUP BY InvoiceNo;

-- Count rows that are cancellations.
SELECT COUNT(*) AS num_cancellations
FROM raw_data
WHERE REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$');

-- Investigate invoices indicating cancellations.
SELECT InvoiceNo,
    LIST(DISTINCT StockCode) AS StockCodes,
    LIST(DISTINCT Description) AS Descriptions,
    LIST(DISTINCT Quantity) AS Quantities,
    LIST(DISTINCT UnitPrice) AS UnitPrices,
    LIST(DISTINCT CustomerID) AS CustomerIDs
FROM raw_data
WHERE InvoiceNo LIKE 'C______'
GROUP BY InvoiceNo;
 
-- Investigate invoices indicating cancellations with StockCode deviations.
SELECT InvoiceNo,
    LIST(DISTINCT StockCode) AS StockCodes,
    LIST(DISTINCT Description) AS Descriptions,
    LIST(DISTINCT Quantity) AS Quantities,
    LIST(DISTINCT UnitPrice) AS UnitPrices,
    LIST(DISTINCT CustomerID) AS CustomerIDs
FROM raw_data
WHERE InvoiceNo LIKE 'C______'
    AND NOT REGEXP_MATCHES(StockCode, '^[0-9]{5}[A-Z]{0,2}$')
GROUP BY InvoiceNo;

-- ---------------------------------------------------------------------------------------------------------------
-- 5. StockCode Validation
-- ---------------------------------------------------------------------------------------------------------------

-- Investigate all StockCode format deviations from 5 digits with 0-2 trailing letters.
SELECT StockCode,
    COUNT(*) AS num_StockCode,
    LIST(DISTINCT InvoiceNo) AS InvoiceNos,
    LIST(DISTINCT Description) AS Descriptions,
    LIST(DISTINCT Quantity) AS Quantities,
    LIST(DISTINCT UnitPrice) AS UnitPrices,
    LIST(DISTINCT CustomerID) AS CustomerIDs
FROM raw_data
WHERE NOT REGEXP_MATCHES(StockCode, '^[0-9]{5}[a-zA-Z]{0,2}$')
GROUP BY StockCode
ORDER BY num_StockCode DESC;

-- Investigate rows with sample products.
SELECT *
FROM raw_data
WHERE StockCode = 'S';

-- ---------------------------------------------------------------------------------------------------------------
-- 6. Quantity Validation
-- ---------------------------------------------------------------------------------------------------------------

-- Count rows with negative Quantity values.
SELECT COUNT(*) AS num_negative_quantities
FROM raw_data
WHERE Quantity < 0;

-- Count rows with 0 Quantity values.
SELECT COUNT(*) AS num_zero_quantities
FROM raw_data
WHERE Quantity = 0;

-- Check for cancellations with positive Quantity values.
SELECT DISTINCT Quantity
FROM raw_data
WHERE REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$')
    AND Quantity > 0;

-- ---------------------------------------------------------------------------------------------------------------
-- 7. InvoiceDate Validation
-- ---------------------------------------------------------------------------------------------------------------

-- Determine InvoiceDate format by looking at maximum values for first and second split parts of format.
SELECT MAX(CAST(SPLIT_PART(InvoiceDate, '/', 1) AS INTEGER)) AS first_part_max,
    MAX(CAST(SPLIT_PART(InvoiceDate, '/', 2) AS INTEGER)) AS second_part_max
FROM raw_data;

-- Investigate InvoiceDate format deviations from M/D/YY H:MM.
SELECT InvoiceDate
FROM raw_data
WHERE NOT REGEXP_MATCHES(InvoiceDate, '^\d{1,2}/\d{1,2}/\d{2} \d{1,2}:\d{2}$');

-- Investigate InvoiceDate range of dates.
SELECT MIN(STRPTIME(InvoiceDate, '%m/%d/%y %H:%M')) AS start_date,
    MAX(STRPTIME(InvoiceDate, '%m/%d/%y %H:%M')) AS end_date
FROM raw_data;

-- ---------------------------------------------------------------------------------------------------------------
-- 8. UnitPrice Validation
-- ---------------------------------------------------------------------------------------------------------------
-- Investigate negative or 0 UnitPrice values.
SELECT Description,
    COUNT(*) AS num_descriptions
FROM raw_data
WHERE UnitPrice <= 0
GROUP BY Description
ORDER BY num_descriptions DESC;

-- ---------------------------------------------------------------------------------------------------------------
-- 9. CustomerID Validation
-- ---------------------------------------------------------------------------------------------------------------
-- Investigate CustomerID format deviations from 5 digits.
SELECT *
FROM raw_data
WHERE CustomerID < 10000 OR CustomerID > 99999;

-- ---------------------------------------------------------------------------------------------------------------
-- 10. Country Validation
-- ---------------------------------------------------------------------------------------------------------------

-- Investigate Country values and occurrence rates.
SELECT Country,
    COUNT(*) AS num_occurences
FROM raw_data
GROUP BY Country
ORDER BY num_occurences DESC;