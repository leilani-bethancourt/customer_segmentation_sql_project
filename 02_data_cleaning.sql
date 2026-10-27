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
CREATE OR REPLACE VIEW convert_date AS 
SELECT * EXCLUDE InvoiceDate,
    STRPTIME(InvoiceDate, '%m/%d/%y %H:%M') AS InvoiceDate
FROM raw_data;

-- ---------------------------------------------------------------------------------------------------------------
-- 2. Remove Rows Unrelated to Customer Purchases
-- ---------------------------------------------------------------------------------------------------------------
-- Remove rows where InvoiceNo begins with 'A'.
CREATE OR REPLACE VIEW remove_bad_debt_adjustments AS
SELECT *
FROM convert_date
WHERE InvoiceNo NOT LIKE 'A______';

-- Remove rows with StockCode values of 'CRUK' and 'S', with negative Quantity.
CREATE OR REPLACE VIEW remove_unrelated_stock_code AS
SELECT *   
FROM remove_bad_debt_adjustments
WHERE NOT ((StockCode = 'CRUK' OR StockCode = 'S') AND Quantity < 0);

-- Remove rows with missing CustomerID, which also removes all rows with missing Description.
CREATE OR REPLACE VIEW remove_missing_values AS
SELECT *  
FROM remove_unrelated_stock_code
WHERE CustomerID IS NOT NULL;

-- ---------------------------------------------------------------------------------------------------------------
-- 3. Initial Data Validation
-- ---------------------------------------------------------------------------------------------------------------
-- Name the initial cleaned dataset.
CREATE OR REPLACE VIEW initial_cleaned_dataset AS
SELECT *
FROM remove_missing_values;

-- Count rows removed from each cleaning view and the initial cleaned dataset.
WITH individual_row_counts AS (
    SELECT (SELECT COUNT(*) FROM convert_date) 
        - (SELECT COUNT(*) FROM remove_bad_debt_adjustments) AS debt_difference,
        (SELECT COUNT(*) FROM remove_bad_debt_adjustments) 
        - (SELECT COUNT(*) FROM remove_unrelated_stock_code) AS stock_difference,
        (SELECT COUNT(*) FROM remove_unrelated_stock_code) 
        - (SELECT COUNT(*) FROM remove_missing_values) AS missing_difference)
SELECT debt_difference,
    stock_difference,
    missing_difference,
    debt_difference + stock_difference + missing_difference AS total_difference
FROM individual_row_counts;

-- Validate the schema of the cleaned dataset.
DESCRIBE initial_cleaned_dataset;

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