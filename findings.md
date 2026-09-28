# Findings

## Data Validation Findings
 
### Missing Values
- 135080 null values for CustomerID column
- 1454 null values for Description column
    - all values for CustomerID column is null for these rows as well

### Invalid or Unexpected Values
- InvoiceNo: three rows have codes starting with the letter 'a', standing for "Adjust bad debt", adjusting the same number (11062.06)
- StockCode: 33 code formats deviate from the described format (codes are recorded in Data Dictionary)
- Quantity: 1,336 rows, not associated with InvoiceNo values indicating cancellations, have negative values, with a unit price of 0
    - 862 rows have no descriptions, while other descriptions indicate damages, checks, or unknown reasons indicated by "?"

### Source Inaccuracy
- the source reports no missing values for all columns in its metadata; however, inspection of the downloaded dataset found 1,454 NULL Description values (0.27%) and 135,080 NULL CustomerID values (24.93%), out of 541,909 total rows
- the source is missing formats for values in the InvoiceNo and StockCode columns

### Data Consistency
- ...

### Data Quality Decisions

## Customer Segmentation

## Cancellations

## Geography

## Product

## Pricing
