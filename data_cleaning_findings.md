# Data Cleaning Findings

>*Document data cleaning findings from 02_data_cleaning.sql, cleaning decisions implemented, and their justifications.*

## Missing Values
- Remove all missing `CustomerID` values, which also removes all `Description` values, 

## Duplicates
- Duplicate rows were not removed because it cannot be determined whether they're errors or legitimate line items.
- Retaining these rows may inflate monetary values if they represent erroneous duplicates.