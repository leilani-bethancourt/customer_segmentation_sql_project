-- ===============================================================================================================
-- Project:     Customer Segmentation & Behavioral Analysis
-- File:        02_data_cleaning.sql
-- Purpose:     Apply data cleaning actions and create the RFM analytical dataset.
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
-- 2. Remove Rows Unrelated to Customer Purchases (except negative Quantity)
-- ---------------------------------------------------------------------------------------------------------------
-- Remove rows where InvoiceNo begins with 'A'.
remove_bad_debt_adjustments AS (
    SELECT *
    FROM convert_date
    WHERE InvoiceNo NOT LIKE 'A______'
    ),

-- Remove rows with StockCode values of 'CRUK' and 'S', with negative Quantity.
remove_unrelated_stock_code AS (
    SELECT *
    FROM remove_bad_debt_adjustments
    WHERE NOT ((StockCode = 'CRUK' OR StockCode = 'S') AND Quantity < 0)
    ),

-- Remove rows with missing CustomerID, which also removes all rows with missing Description.
remove_missing_values AS (
    SELECT *
    FROM remove_unrelated_stock_code
    WHERE CustomerID IS NOT NULL
    )
SELECT *
FROM remove_missing_values;

-- ---------------------------------------------------------------------------------------------------------------
-- 3. Initial Data Validation
-- ---------------------------------------------------------------------------------------------------------------
-- Count remaining rows in the cleaned dataset.

-- Validate the schema of the cleaned dataset.

-- ---------------------------------------------------------------------------------------------------------------
-- 4. Investigate Negative Quantities
-- ---------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------
-- 5. Investigate Unit Prices of 0
-- ---------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------
-- 6. Data Standardization
-- ---------------------------------------------------------------------------------------------------------------
-- Standardize StockCode values.

-- ---------------------------------------------------------------------------------------------------------------
-- 7. Final Data Validation
-- ---------------------------------------------------------------------------------------------------------------
-- Count remaining rows in the cleaned dataset.

-- Validate the schema of the cleaned dataset.