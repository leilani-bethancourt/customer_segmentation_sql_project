-- ===============================================================================================================
-- Project:     Customer Segmentation & Behavioral Analysis
-- File:        02_data_cleaning.sql
-- Purpose:     Apply cleaning decisions, standardize values, and create the analytical dataset.
-- ===============================================================================================================

-- ---------------------------------------------------------------------------------------------------------------
-- 1. Data Loading and Schema Validation
-- ---------------------------------------------------------------------------------------------------------------
-- Load raw dataset.
CREATE OR REPLACE VIEW raw_data AS
SELECT *
FROM read_csv('data/online_retail.csv', types={'InvoiceDate': 'VARCHAR'});

-- Validate the schema of the dataset.
DESCRIBE raw_data;

-- Convert InvoiceDate from VARCHAR to TIMESTAMP using MM/DD/YY HH:MM format.
WITH convert_date AS (
    SELECT * EXCLUDE InvoiceDate,
        STRPTIME(InvoiceDate, '%m/%d/%y %H:%M') AS InvoiceDate
    FROM raw_data
    ),

-- ---------------------------------------------------------------------------------------------------------------
-- 4. Remove Rows Unrelated to Customer Purchases (except negative Quantity)
-- ---------------------------------------------------------------------------------------------------------------
-- Remove rows with missing CustomerID, which also removes all rows with missing Description.
remove_missing_values AS (
    SELECT *
    FROM convert_date
    WHERE CustomerID IS NOT NULL
    ),

-- Remove rows where InvoiceNo begins with 'A'.
remove_debt_adjustments AS (
    SELECT *
    FROM remove_missing_values
    WHERE InvoiceNo NOT LIKE 'A______'
    ),

-- ---------------------------------------------------------------------------------------------------------------
-- 5. Investigate Negative Quanitities that are not Cancellations
-- ---------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------
-- 6. Data Standardization
-- ---------------------------------------------------------------------------------------------------------------
-- Standardize StockCode values.

-- ---------------------------------------------------------------------------------------------------------------
-- 7. Final Data Validation
-- ---------------------------------------------------------------------------------------------------------------
-- Sum total number of excess exact row duplicates and find monetary impact of removing them.
WITH duplicates AS (
    SELECT *,
        COUNT(*) - 1 AS num_excess_duplicates
    FROM cleaned_data
    GROUP BY ALL
    HAVING COUNT(*) > 1
)
SELECT SUM(num_excess_duplicates) AS total_excess_duplicates,
    SUM(Quantity * UnitPrice * num_excess_duplicates) AS net_monetary_impact,
    SUM(ABS(Quantity) * UnitPrice * num_excess_duplicates) AS absolute_monetary_impact

-- Count remaining rows in the cleaned dataset.

-- Validate the schema of the cleaned dataset.