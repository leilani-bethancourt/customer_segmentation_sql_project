# Data Cleaning

>*Document data cleaning decisions and their justifications from 02_data_cleaning.sql.*

## InvoiceDate
**Action:** Convert `InvoiceDate` from VARCHAR to TIMESTAMP. 

**Reason:** Standardize and remove ambiguity around TIMESTAMP format.

## Duplicates
- Retaining these rows would inflate monetary value if they do represent erroneous duplicates, but there was no reason to be found to justify that they are, so duplicates are kept.
    - Exact row duplicates are realistic because a customer can purchase the same amount of the same product on the same invoice at the same time multiple times, resulting in the same stock code, description, country, and unit price.

## InvoiceNo
**Action:** Exclude three rows indicating an adjustment of bad debt.

**Reason:** Exclude transactions that do not represent customer purchases.

## StockCode
**Action:** Exclude rows indicating research comission or free sample products for customers.

**Reason:** Exclude transactions that do not represent customer purchases.

## Missing Values
**Action:** Remove all missing `CustomerID` values, which also removes all `Description` values.

**Reason:** Exclude invoices that cannot be traced back to a customer purchase.