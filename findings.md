# Findings

## Data Validation Findings
 
### Missing Values
- 1454 null values for Description column
    - all values for CustomerID column is null for these rows as well
    - there are 
- 135080 null values for CustomerID column


### Invalid or Unexpected Values
- three rows in the InvoiceNo column have codes starting with the letter 'a'
    - the Description column says "Adjust bad debt"
    - the UnitPrice column lists [11062.06, -11062.06, -11062.06]

### Source Inaccuracy
- the source says there should be no missing values but there are null values for the Description and CustomerID columns
- the source does not describe formats for values in the InvoiceNo column involving codes starting with the letter 'a'

### Data Consistency
- ...

### Data Quality Decisions

## Customer Segmentation

## Cancellations

## Geography

## Product

## Pricing
