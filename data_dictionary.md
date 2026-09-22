# Data Dictionary
A reference for the tables/columns used.

| Variable Name | Role | Type | Description	Units | Missing Values |
|---|---|---|---|---|
| InvoiceNo | ID | Categorical | A 6-digit integral number uniquely assigned to each transaction. If this code starts with the letter 'C', it indicates a cancellation. | no |
| StockCode | ID | Categorical | A 5-digit integral number uniquely assigned to each distinct product. | no |
| Description | Feature | Categorical | The product name. | yes* |
| Quantity | Feature | Integer | The quantity of each product (item) per transaction. | no |
| InvoiceDate | Feature | Date | The day and time when each transaction was generated. | no |
| UnitPrice | Feature | Continuous | The price of the product per unit, in pounds sterling. | no |
| CustomerID | ID | Categorical | A 5-digit integral number uniquely assigned to each customer. | yes* |
| Country | Feature | Categorical | The name of the country where each customer resides. | no |

*UCI reports no missing values for all columns in its metadata; however, inspection of the downloaded dataset found 1,454 NULL Description values (0.27%) and 135,080 NULL CustomerID values (24.93%), out of 541,909 total rows. 