# Data Dictionary
A reference for the tables/columns used.

## Original Source Data Dictionary

| Variable Name | Role | Type | Description	Units | Missing Values |
|---|---|---|---|---|
| InvoiceNo | ID | Categorical | a 6-digit integral number uniquely assigned to each transaction. If this code starts with letter 'c', it indicates a cancellation | no |
| StockCode | ID | Categorical | a 5-digit integral number uniquely assigned to each distinct product  | no |
| Description | Feature | Categorical | product name | no |
| Quantity | Feature | Integer | the quantities of each product (item) per transaction | no |
| InvoiceDate | Feature | Date | the day and time when each transaction was generated | no |
| UnitPrice | Feature | Continuous | product price per unit | no |
| CustomerID | ID | Categorical | a 5-digit integral number uniquely assigned to each customer | no |
| Country | Feature | Categorical | the name of the country where each customer resides | no |


## Updated Data Dictionary after Data Understanding

| Variable Name | Role | Type | SQL Data Type | Description	Units | Missing Values |
|---|---|---|---|---|---|
| InvoiceNo | ID | Categorical | VARCHAR | A 6-digit integral number uniquely assigned to each transaction. If this code starts with the letter 'C', it indicates a cancellation. If this code starts with the letter 'A', it indicates a bad debt adjustment. | no |
| StockCode | ID | Categorical | VARCHAR | A 5-digit integral number uniquely assigned to each distinct product, sometimes with a letter or two at the end. Other common code formats are listed in "Common StockCode Deviation Codes and Descriptions" below. | no |
| Description | Feature | Categorical | VARCHAR | The product name or transaction description. | yes |
| Quantity | Feature | Integer | BIGINT | The quantity of each product (item) per transaction. Negative values can indicate cancellations, damages, or checks. | no |
| InvoiceDate | Feature | Date | TIMESTAMP | The day and time when each transaction was generated, ranging from January 12, 2010 to September 12, 2011. | no |
| UnitPrice | Feature | Continuous | DOUBLE | A positive price of the product per unit, in pounds sterling. (Two rows contain negative pricing for adjusting bad debt). | no |
| CustomerID | ID | Categorical | BIGINT | A 5-digit integral number uniquely assigned to each customer. | yes |
| Country | Feature | Categorical | VARCHAR | The name of the country where each customer resides. | no |

### Common StockCode Deviation Codes and Descriptions
| StockCode    | Description(s)                                                         |
| ------------ | ---------------------------------------------------------------------- |
| POST         | POSTAGE                                                                |
| DOT          | DOTCOM POSTAGE                                                         |
| M            | Manual                                                                 |
| C2           | CARRIAGE                                                               |
| D            | Discount                                                               |
| S            | SAMPLES                                                                |
| BANK CHARGES | Bank Charges                                                           |
| AMAZONFEE    | AMAZON FEE                                                             |
| CRUK         | CRUK Commission                                                        |
| B            | Adjust bad debt                                                        |