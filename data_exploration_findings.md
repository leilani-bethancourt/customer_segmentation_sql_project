# Data Exploration Findings

>*Document data-quality findings from 01_data_exploration.sql, cleaning decisions implemented in 02_data_cleaning.sql, and their justifications.*

## Schema

- The dataset contains 541,909 records, matching the expected row count.

## Null Values

**Issue:** `Description` has 1,454 missing values and `CustomerID` has 135,080 missing values. (All null `Description` values are also rows with null `CustomerID` values.)

**Action:** Exclude rows with missing `CustomerID` values from the analytical dataset, but leave records in the raw dataset for traceability. 

**Purpose:** Exclude transactions that cannot be traced back to a customer purchase.

## Duplicate Values

**Issue:** 5,268 excess exact row duplicates were found. 

**Action:** Exclude excess exact row duplicates from the analytical dataset, but leave records in the raw dataset for traceability.

**Purpose:** Exclude duplicates to avoid inflation of metrics.

## Variable Investigation

### InvoiceNo

- 9,288 rows are cancellations and have negative quantity.

**Issue:** Three records have `InvoiceNo` values beginning with `A` and contain the description `Adjust bad debt`. All three records adjust the same amount (£11,062.06).

**Action:** Exclude these records from the analytical dataset, but leave records in the raw dataset for traceability.

**Purpose:** Exclude transactions that do not represent customer purchases.

### StockCode

**Issue:** 2,995 records deviate from the `StockCode` format, with 33 distinct codes. Code deviations are listed below, under "Common StockCode Format Deviations".

**Action:** Exclude records unrelated to customer purchases from the analytical dataset, but leave records in the raw dataset for traceability.

**Purpose:** Exclude transactions that do not represent customer purchases.

**Common StockCode Format Deviations**

| Code | Occurrences | Description(s) | Interpreted Meaning |
|---|---|---|---|
| `POST` | 1256 | POSTAGE | Delivery charge |
| `DOT` | 710 | DOTCOM POSTAGE | Delivery charge |
| `M` or `m` | 572 | Manual | Manual invoice entry |
| `C2` | 144 | CARRIAGE | Delivery charge |
| `D` | 77 | Discount | Discount |
| `S` | 63 | SAMPLES | Sample product |
| `BANK CHARGES` | 37 | Bank Charges | Bank charge |
| `AMAZONFEE` | 34 | AMAZON FEE | Delivery charge |
| `CRUK` | 16 | CRUK Commission | Cancer Research UK commission charge |
| `DCGS...` or `gift_0001_...`| 79 | varies | Dotcomgiftshop products |
| `PADS` | 3 | PADS TO MATCH ALL CUSHIONS" | Product description |
| `B` | 3 | Adjust bad debt | Adjustment |


### Quantity

- 10,624 rows have negative values. 
- All rows with InvoiceNo indicating cancellations also have negative quantities.
- 1,336 negative-quantity rows remain after excluding standard cancellations and selected non-product StockCodes. Further investigation identified missing descriptions, damaged or discarded products, inventory adjustments, and unexplained records.    
    - 862 rows have null Description values
    - Other rows indicate damaged/lost/discarded products, adjustments, entry/sales mistakes, and unexplained records.

### InvoiceDate

- Invoice dates are in mm/dd/yy HH:MM format.
- Invoice dates range from December 1, 2010 at 08:26 to December 9, 2011 at 12:50.

**Issue:** Automatic timestamp parsing failed due to ambiguity in the source date format.

**Action:** Initially converted `InvoiceDate` to VARCHAR, then to TIMESTAMP. 

**Purpose:** Standardize and remove ambiguity around TIMESTAMP format.

### UnitPrice

- 2 rows have negative `UnitPrice` values for "Adjust bad debt" and null `CustomerID`.
- 2,515 rows have a `UnitPrice` value of 0, most having `Description` as missing, "check", "?", "damages", "damaged", "found", or "adjustment".

### CustomerID

- All `CustomerID` values are five digits.

### Country

- Countries (in order of occurence) include the United Kingdom, Germany, France, EIRE, Spain, Netherlands, Belgium, Switzerland, Portugal, Australia, Norway, Italy, Channel Islands, Finland, Cyprus, Sweden, Austria, Denmark, Japan, Poland, Israel, USA, Hong Kong, Singapore, Iceland, Canada, Greece, Malta, United Arab Emirates, European Community, RSA, Lebanon, Lithuania, Brazil, Czech Republic, Bahrain, and Saudi Arabia.
- There are 446 `Unspecified` values.
 
## Source Inaccuracy

- the source reports no missing values for all columns in its metadata; however, inspection of the downloaded dataset found 1,454 NULL Description values (0.27%) and 135,080 NULL CustomerID values (24.93%), out of 541,909 total rows
- the source is missing formats for values in the InvoiceNo and StockCode columns