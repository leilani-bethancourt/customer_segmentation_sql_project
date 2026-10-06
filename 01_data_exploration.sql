-- =========================================================================================================================================
-- Project:     Customer Segmentation & Behavioral Analysis
-- File:        01_data_exploration.sql
-- Purpose:     Profile raw data, validate schema, identify quality issues
-- =========================================================================================================================================

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 1. DATA VALIDATTION
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- Load InvoiceDate as VARCHAR to prevent automatic date parsing errors caused by inconsistent source formatting.
CREATE OR REPLACE VIEW raw_data AS
SELECT * 
FROM read_csv('./data/online_retail.csv', types={'InvoiceDate': 'VARCHAR'});

-- Inspect the first ten rows of raw data.
SELECT * FROM raw_data LIMIT 10;

-- Check the total number of records imported.
SELECT COUNT(*) as row_count FROM raw_data;  

-- Verify the imported column data types.
DESCRIBE raw_data;

-- Check the total number of nulls for each column.
SELECT
    COUNT(*) AS total_rows,
    total_rows - COUNT(InvoiceNo) AS InvoiceNo_present,
    total_rows - COUNT(StockCode) AS StockCode_present,
    total_rows - COUNT(Description) AS Description_present,
    total_rows - COUNT(Quantity) AS Quantity_present,
    total_rows - COUNT(InvoiceDate) AS InvoiceDate_present,
    total_rows - COUNT(UnitPrice) AS UnitPrice_present,
    total_rows - COUNT(CustomerID) AS CustomerID_present,
    total_rows - COUNT(Country) AS Country_present
FROM raw_data;

-- Sum total number of excess exact row duplicates.
WITH duplicates AS (
    SELECT *,
        COUNT(*) - 1 AS excess_duplicates
    FROM raw_data
    GROUP BY ALL
    HAVING COUNT(*) > 1
)
SELECT SUM(excess_duplicates) AS total_excess_duplicates
FROM duplicates;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- InvoiceNo INVESTIGATION -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- Investigate InvoiceNo format deviations from 6 digits or 6 digits with a leading 'C'.
SELECT *
FROM raw_data
WHERE NOT (
    REGEXP_MATCHES(InvoiceNo, '^[0-9]{6}$')
    OR REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$'));

-- Count rows that are cancellations.
SELECT COUNT(*) AS num_cancellations
FROM raw_data
WHERE REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$');

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- StockCode INVESTIGATION -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- Investigate all StockCode format deviations from 5 digits with 0-2 trailing letters.
SELECT StockCode,
    COUNT(StockCode) AS StockCode_no,
    LIST(DISTINCT InvoiceNo) AS InvoiceNos,
    LIST(DISTINCT Description) AS Descriptions,
    LIST(DISTINCT Quantity) AS Quantities,
    LIST(DISTINCT UnitPrice) AS UnitPrices,
    LIST(DISTINCT CustomerID) AS CustomerIDs
FROM raw_data
WHERE NOT REGEXP_MATCHES(StockCode, '^[0-9]{5}[a-zA-Z]{0,2}$')
GROUP BY StockCode
ORDER BY StockCode_no DESC;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Quantity INVESTIGATION ------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- Count rows with negative Quantity values.
SELECT COUNT(*) AS num_negative_quantities
FROM raw_data
WHERE Quantity < 0;

-- Confirm Quantity values for cancellations are negative.
SELECT DISTINCT Quantity
FROM raw_data
WHERE REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$')
    AND Quantity > 0;

-- Count rows with negative Quantity values associated with customer purchases.
SELECT COUNT(*) AS num_negative_quantities,
FROM raw_data
WHERE NOT REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$')
    AND (StockCode NOT IN ('POST', 'DOT', 'C2', 'D', 'S', 'BANK CHARGES', 'AMAZONFEE', 'CRUK', 'B'))
    AND Quantity < 0;

-- Investigate negative Quantity values associated with customer purchases.
SELECT COUNT(*) AS invoices_total_per_description,
    LIST(DISTINCT InvoiceNo) AS InvoiceNos,
    Description,
    LIST(DISTINCT Quantity) AS Quantities,
    LIST(DISTINCT UnitPrice) AS UnitPrices,
    LIST(DISTINCT StockCode) AS StockCodes,
    LIST(DISTINCT CustomerID) AS CustomerIDs
FROM raw_data
WHERE NOT REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$')
    AND (StockCode NOT IN ('POST', 'DOT', 'C2', 'D', 'S', 'BANK CHARGES', 'AMAZONFEE', 'CRUK', 'B'))
    AND Quantity < 0
GROUP BY Description
ORDER BY invoices_total_per_description DESC;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- InvoiceDate INVESTIGATION ---------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- Determine InvoiceDate format by looking at maximum values for first and second split parts of format.
SELECT MAX(CAST(SPLIT_PART(InvoiceDate, '/', 1) AS INTEGER)) AS first_part_max,
    MAX(CAST(SPLIT_PART(InvoiceDate, '/', 2) AS INTEGER)) AS second_part_max
FROM raw_data;

-- Investigate InvoiceDate format deviations from mm/dd/yy MM:SS.
SELECT InvoiceDate
FROM raw_data
WHERE NOT REGEXP_MATCHES(InvoiceDate, '^\d{1,2}/\d{1,2}/\d{2} \d{1,2}:\d{2}$');

-- Investigate InvoiceDate range of dates.
WITH dates AS (
    SELECT InvoiceDate
    FROM raw_data
    WHERE 
)
SELECT InvoiceDate
FROM dates
ORDER BY InvoiceDate;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- UnitPrice INVESTIGATION -----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Investigate negative UnitPrice values.
SELECT *
FROM original_data
WHERE UnitPrice < 0;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- CustomerID INVESTIGATION ----------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Investigate CustomerID format deviations from 5 digits.
SELECT *
FROM original_data
WHERE NOT REGEXP_MATCHES(CustomerID, '^[0-9]{5}$');

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- Country INVESTIGATION -------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- Investigate Country values.
SELECT Country
FROM original_data
GROUP BY Country;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- 2. DATA CLEANING
-- -----------------------------------------------------------------------------------------------------------------------------------------

-- Remove excess exact row duplicates. 

-- Remove rows with missing values for CustomerID and Description.
CREATE OR REPLACE VIEW cleaning_data AS
SELECT *
FROM cleaning_data
WHERE CustomerID IS NOT NULL
    OR REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$')
    OR Quantity <= 0;

-- Exclude `InvoiceNo` values beginning with `A`.

-- Exclude `StockCode` values that do not pertain to customer purchases.

-- Convert InvoiceDate from VARCHAR to TIMESTAMP using MM/DD/YY HH:MM format.
CREATE OR REPLACE VIEW cleaning_data AS
SELECT * EXCLUDE InvoiceDate,
    STRPTIME(InvoiceDate, '%m/%d/%y %H:%M:%S') AS InvoiceDate
FROM raw_data;

-- Add column that indicates if the row is a valid invoice, cancellation, or other?
