# Data Exploration Findings

>*Document all data findings from 01_data_exploration.sql.*

## Schema

- The dataset contains 541,909 records, matching the expected row count.

## Null Values

- There are 1,454 missing values for `Description`.
- There are 135,080 missing values for `CustomerID` (which include missing values for `Description`).

## Duplicates
- There are 5,268 EXCESS duplicate rows.
    - Removing these rows would result in a net monetary difference of approximately £21,740.98, or an absolute monetary difference of approximately £27,406.50.
- There are 4,879 unique rows that have duplicates.

## Variable Investigation

### InvoiceNo

- 9,288 rows are indicated as cancellations and all have negative quantities.
    - Some rows indicated as cancellations are not actually cancellations, but things like samples (as indicated by StockCode).
- There are 3,836 unique cancellation invoices.
    - There are 477 unique cancellation invoices that have `StockCode` deviation codes.
- There are 25,900 unique invoices.
- 3 rows have `InvoiceNo` values beginning with `A` and contain the description `Adjust bad debt`. All three records adjust the same amount (£11,062.06).

### StockCode
- There are 2,995 rows that deviate from the standard format, with 33 distinct deviation codes.
- There are 477 unique cancellation invoices that have `StockCode` deviation codes.

**Common StockCode Format Deviations**

| Code | Occurrences | Description(s) | Interpreted Meaning |
|---|---|---|---|
| `POST` | 1256 | POSTAGE | `Delivery Charge` |
| `DOT` | 710 | DOTCOM POSTAGE | `Delivery Charge` |
| `M` or `m` | 572 | Manual | `Manual Entry` |
| `C2` | 144 | CARRIAGE | `Delivery Charge` |
| `D` | 77 | Discount | `Discount` |
| `S` | 63 | SAMPLES | `Sample product` |
| `BANK CHARGES` | 37 | Bank Charges | `Bank Charge` |
| `AMAZONFEE` | 34 | AMAZON FEE | `Delivery Charge` |
| `CRUK` | 16 | CRUK Commission | `Cancer Research UK Commission` |
| `DCGS...` or `gift_0001_...`| 79 | varies | `Product Description` |
| `PADS` | 3 | PADS TO MATCH ALL CUSHIONS" | `Product Description` |
| `B` | 3 | Adjust bad debt | `Debt Adjustment` |

### Description

- There are 1,454 missing `Description` values. All of these records also have missing `CustomerID` values.

### Quantity

- 10,624 rows have negative values. 
    - All rows with InvoiceNo indicating cancellations have negative quantities.

### InvoiceDate

- Invoice dates are in M/D/YY H:MM format.
- Invoice dates range from December 1, 2010 at 08:26 to December 9, 2011 at 12:50.
- There are no deviations from the standard format.

### UnitPrice

- 2 rows have negative `UnitPrice` values for "Adjust bad debt" and null `CustomerID`.
- 2,515 rows have a `UnitPrice` value of 0, most having `Description` as missing, "check", "?", "damages", "damaged", "found", or "adjustment".

### CustomerID

- There are 135,080 rows with missing `CustomerID`.
- There are no deviations from the standard format.

### Country

- Countries (in order of occurence) include the United Kingdom, Germany, France, EIRE, Spain, Netherlands, Belgium, Switzerland, Portugal, Australia, Norway, Italy, Channel Islands, Finland, Cyprus, Sweden, Austria, Denmark, Japan, Poland, Israel, USA, Hong Kong, Singapore, Iceland, Canada, Greece, Malta, United Arab Emirates, European Community, RSA, Lebanon, Lithuania, Brazil, Czech Republic, Bahrain, and Saudi Arabia.
- There are 446 `Unspecified` values.
 
## Source Inaccuracy

- the source reports no missing values for all columns in its metadata; however, inspection of the downloaded dataset found 1,454 NULL Description values (0.27%) and 135,080 NULL CustomerID values (24.93%), out of 541,909 total rows
- the source is missing formats for values in the InvoiceNo and StockCode columns