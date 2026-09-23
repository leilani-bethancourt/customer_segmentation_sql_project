-- --------------------------------------------------------------------------------------------------------
-- 1. LOAD DATA
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

-- --------------------------------------------------------------------------------------------------------
-- 2. DATA UNDERSTANDING
-- --------------------------------------------------------------------------------------------------------
-- check data types
DESCRIBE original_data;

-- look at first ten rows
SELECT *
FROM original_data
LIMIT 10;

-- --------------------------------------------------------------------------------------------------------
-- 3. INVESTIGATE NULL VALUES
-- --------------------------------------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    total_rows - COUNT(InvoiceNo) AS InvoiceNo_present,
    total_rows - COUNT(StockCode) AS StockCode_present,
    total_rows - COUNT(Description) AS Description_present, -- 1454 nulls
    total_rows - COUNT(Quantity) AS Quantity_present,
    total_rows - COUNT(InvoiceDate) AS InvoiceDate_present,
    total_rows - COUNT(UnitPrice) AS UnitPrice_present,
    total_rows - COUNT(CustomerID) AS CustomerID_present, -- 135080 nulls
    total_rows - COUNT(Country) AS Country_present
FROM original_data;

-- investigate rows with null values for both Description and CustomerID
SELECT *
FROM original_data
WHERE Description IS NULL AND CustomerID IS NULL;

-- --------------------------------------------------------------------------------------------------------
-- 3. DATA CLEANING
-- --------------------------------------------------------------------------------------------------------
-- create new table for customer-level analysis, excluding rows where CustomerID is null, automatically excluding bad debt adjustment rows
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
-- 4. DATA EXPLORATION
-- --------------------------------------------------------------------------------------------------------
-- investigate StockCode deviations
SELECT StockCode
FROM customer_retail
WHERE StockCode NOT LIKE '_____' AND StockCode NOT LIKE '______' AND StockCode NOT LIKE '_______'
GROUP BY StockCode;

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
