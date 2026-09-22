-- --------------------------------------------------------------------------------------------------------
-- 1. LOAD DATA
-- --------------------------------------------------------------------------------------------------------
-- convert InvoiceDate from error-causing TIMESTAMP to VARCHAR with proper timestamp format
CREATE OR REPLACE VIEW retail AS
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
-- 2. NULL DATA EXPLORATION
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
FROM retail;

-- --------------------------------------------------------------------------------------------------------
-- 3. DATA CLEANING
-- --------------------------------------------------------------------------------------------------------
-- create new table for customer-level analysis, excluding rows where CustomerID is null
CREATE OR REPLACE VIEW nonNullCustomerIDs AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
FROM retail
WHERE CustomerID IS NOT NULL;

-- create new table for customer-level financial analysis, making all  rows where CustomerID is null
CREATE OR REPLACE VIEW nonNullCustomerIDs AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country
FROM retail
WHERE CustomerID IS NOT NULL;


-- --------------------------------------------------------------------------------------------------------
-- 4. DATA EXPLORATION
-- --------------------------------------------------------------------------------------------------------
-- identify specific customer transaction counts, total quantity bought, and total amount spent
SELECT 
    CustomerID,
    COUNT(*) AS TransactionCount,
    SUM(Quantity) AS TotalQuantity,
    SUM(Quantity*UnitPrice) AS TotalSpent
FROM retail
GROUP BY CustomerID
ORDER BY TotalSpent DESC;
-- null CustomerIDs had 135080 transactions, 269562 items bought, and a total of 1447682.1200000737 spent
