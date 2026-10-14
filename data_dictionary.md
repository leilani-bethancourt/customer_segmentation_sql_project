# Data Dictionary
>*Define columns, data types, and their meanings.*

## Original Data Dictionary
*Source: [UCI Online Retail Dataset](https://archive.ics.uci.edu/dataset/352/online%2Bretail).*

| Variable Name | Role | Type | Description	Units | Missing Values |
|---|---|---|---|---|
| `InvoiceNo` | ID | Categorical | a 6-digit integral number uniquely assigned to each transaction. If this code starts with letter 'c', it indicates a cancellation | no |
| `StockCode` | ID | Categorical | a 5-digit integral number uniquely assigned to each distinct product  | no |
| `Description` | Feature | Categorical | product name | no |
| `Quantity` | Feature | Integer | the quantities of each product (item) per transaction | no |
| `InvoiceDate` | Feature | Date | the day and time when each transaction was generated | no |
| `UnitPrice` | Feature | Continuous | product price per unit | no |
| `CustomerID` | ID | Categorical | a 5-digit integral number uniquely assigned to each customer | no |
| `Country` | Feature | Categorical | the name of the country where each customer resides | no |


## Validated Data Dictionary 
*The validated data dictionary reflects the actual structure and characteristics identified during data exploration. It documents discrepancies between the source metadata and the imported dataset, including missing values, nonstandard identifiers, and unexpected transaction types.*

| Variable Name | Role | Type | SQL Data Type | Description | Missing Values |
|---|---|---|---|---|---|
| `InvoiceNo` | ID | Categorical | `VARCHAR` | A transaction identifier, typically consisting of six digits. A leading `C` indicates a cancellation, while a leading `A` identifies bad-debt adjustments in this dataset. | no |
| `StockCode` | ID | Categorical | `VARCHAR` | A product or transaction-type identifier, typically consisting of five digits with zero to two trailing letters. Nonstandard codes may represent postage, discounts, fees, adjustments, or other transactions. | no |
| `Description` | Feature | Categorical | `VARCHAR` | The invoice description. | yes |
| `Quantity` | Feature | Integer | `BIGINT` | The quantity associated with each invoice line. Negative values occur for cancellations and various adjustments or nonstandard transactions. | no |
| `InvoiceDate` | Feature | Date/time | `VARCHAR` | The day and time of each transaction in mm/dd/yy HH:MM format, ranging from December 1, 2010 at 08:26 to December 9, 2011 at 12:50. | no |
| `UnitPrice` | Feature | Continuous | `DOUBLE` | A price of the product per unit, in pounds sterling. | no |
| `CustomerID` | ID | Categorical | `BIGINT` | A unique 5-digit code assigned to each customer. | yes |
| `Country` | Feature | Categorical | `VARCHAR` | The name of the country where each customer resides. | no |

## Cleaned Data Dictionary
*The cleaned data dictionary reflects the final structure and characteristics of the dataset after data cleaning. It documents changes made to the validated source data, including data type conversions, excluded records, standardized values, and any new or modified columns used for analysis.*

To be completed after implementing and validating the data-cleaning transformations in 02_data_cleaning.sql.