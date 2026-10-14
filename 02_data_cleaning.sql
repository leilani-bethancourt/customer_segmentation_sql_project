-- =========================================================================================================================================
-- Project:     Customer Segmentation & Behavioral Analysis
-- File:        01_data_exploration.sql
-- Purpose:     Apply cleaning decisions, standardize values, and create the analytical dataset.
-- =========================================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------
-- 1. 
-- ---------------------------------------------------------------------------------------------------------------

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

-- Convert InvoiceDate from VARCHAR to TIMESTAMP using MM/DD/YY HH:MM format. add weekday?
CREATE OR REPLACE VIEW cleaning_data AS
SELECT * EXCLUDE InvoiceDate,
    STRPTIME(InvoiceDate, '%m/%d/%y %H:%M:%S') AS InvoiceDate
FROM raw_data;

-- Add column that indicates if the row is a valid invoice, cancellation, or other?
