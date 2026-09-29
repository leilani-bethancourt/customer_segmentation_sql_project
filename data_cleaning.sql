-- --------------------------------------------------------------------------------------------------------
-- 1. DATA UNDERSTANDING
-- --------------------------------------------------------------------------------------------------------
-- convert InvoiceDate from error-causing TIMESTAMP to VARCHAR with proper timestamp format
CREATE OR REPLACE VIEW original_data AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    strptime(InvoiceDate, '%m/%d/%y %H:%M') AS InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
FROM read_csv(
    './data/online_retail.csv',
    types = {'InvoiceDate': 'VARCHAR'}
);

-- check data types
DESCRIBE original_data;

-- look at first ten rows
SELECT *
FROM original_data
LIMIT 10;

-- investigate null values
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
FROM original_data;

-- investigate rows with null values for both Description and CustomerID
SELECT *
FROM original_data
WHERE Description IS NULL AND CustomerID IS NULL;

-- investigate InvoiceNo format deviations
SELECT *
FROM original_data
WHERE NOT (
    REGEXP_MATCHES(InvoiceNo, '^[0-9]{6}$')
    OR REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$'));

-- investigate StockCode format deviations
SELECT StockCode,
    COUNT(StockCode) AS StockCode_no,
    LIST(DISTINCT Description) AS Descriptions
FROM original_data
WHERE NOT (
    REGEXP_MATCHES(StockCode, '^[0-9]{5}$')
    OR REGEXP_MATCHES(StockCode, '^[0-9]{5}[a-zA-Z]{1}$')
    OR REGEXP_MATCHES(StockCode, '^[0-9]{5}[a-zA-Z]{2}$'))
GROUP BY StockCode
ORDER BY StockCode_no DESC;

-- investigate negative Quantity values
SELECT Description,
    COUNT(*) AS invoices_total_per_description
FROM original_data
WHERE NOT REGEXP_MATCHES(InvoiceNo, '^C[0-9]{6}$')
    AND Quantity < 0
    AND UnitPrice = 0
GROUP BY Description
ORDER BY invoices_total_per_description DESC;

-- investigate InvoiceDate range
SELECT *
FROM original_data
ORDER BY InvoiceDate DESC;

-- investigate negative UnitPrice
SELECT *
FROM original_data
WHERE UnitPrice < 0;

-- investigate CustomerID format deviations
SELECT *
FROM original_data
WHERE NOT REGEXP_MATCHES(CustomerID, '^[0-9]{5}$');

-- investigate Country values
SELECT Country
FROM original_data
GROUP BY Country;

-- --------------------------------------------------------------------------------------------------------
-- 2. DATA CLEANING
-- --------------------------------------------------------------------------------------------------------
-- create new table for customer-level analysis, excluding rows where CustomerID is null
CREATE OR REPLACE VIEW customer_retail AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
FROM original_data
WHERE CustomerID IS NOT NULL;

-- --------------------------------------------------------------------------------------------------------
-- 5. MEASURE CUSTOMER REVENUE
-- --------------------------------------------------------------------------------------------------------
-- identify specific customer transaction counts, total quantity bought, and total amount spent
SELECT 
    CustomerID,
    COUNT(*) AS TransactionCount,
    SUM(Quantity) AS TotalQuantity,
    SUM(Quantity*UnitPrice) AS TotalSpent
FROM nonNullCustomerIDs
GROUP BY CustomerID
ORDER BY TotalSpent DESC;
-- null CustomerIDs had 135080 transactions, 269562 items bought, and a total of 1447682.1200000737 spent
