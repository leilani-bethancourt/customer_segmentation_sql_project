# Data Dictionary
A reference for the tables/columns used.

| Variable Name | Role | Type | SQL Data Type | Description	Units | Missing Values |
|---|---|---|---|---|---|
| InvoiceNo | ID | Categorical | VARCHAR | A 6-digit integral number uniquely assigned to each transaction. If this code starts with the letter 'C', it indicates a cancellation. If this code starts with the letter 'A', it indicates a bad debt adjustment. | no |
| StockCode | ID | Categorical | VARCHAR | A 5-digit integral number uniquely assigned to each distinct product, sometimes with a letter or two at the end.  | no |
| Description | Feature | Categorical | VARCHAR | The product name. | yes* |
| Quantity | Feature | Integer | BIGINT | The quantity of each product (item) per transaction. | no |
| InvoiceDate | Feature | Date | TIMESTAMP | The day and time when each transaction was generated. | no |
| UnitPrice | Feature | Continuous | DOUBLE | The price of the product per unit, in pounds sterling. | no |
| CustomerID | ID | Categorical | BIGINT | A 5-digit integral number uniquely assigned to each customer. | yes* |
| Country | Feature | Categorical | VARCHAR | The name of the country where each customer resides. | no |

*UCI reports no missing values for all columns in its metadata; however, inspection of the downloaded dataset found 1,454 NULL Description values (0.27%) and 135,080 NULL CustomerID values (24.93%), out of 541,909 total rows. 