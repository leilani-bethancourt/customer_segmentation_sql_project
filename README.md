# Customer Segmentation & Behavioral Analysis

This project uses SQL to analyze customer behavior and develop customer segments using RFM analysis, with additional analysis of revenue, purchase frequency, recency, retention patterns, lifetime value, churn, pricing, promotions, and demand analysis.

**RFM** stands for recency, frequency, and monetary value. Customers are ranked on a scale of 1-5 for each category, with 5-5-5 ranking customers being the best.

> Research Question: Which customer segments should companies prioritize?

### Key Findings
None yet!

### Dataset Used

| Title | URL | From |
|---|---|---|
| online_retail.csv | https://archive.ics.uci.edu/dataset/352/online%2Bretail | UC Irvine Machine Learning Repository |

### Cleaning Data Decisions
| Decision | Rows Affected | % of Data | Rationale | Alternative Considered |
|----------|---------------|-----------|-----------|------------------------|
| Remove cancellations indicated by InvoiceNo | 8,235 | 1.52% | Returns have negative amounts, distort revenue | Keep as churn indicator (future work) |
| Remove missing CustomerID | 135,080 | 24.93% | Cannot segment without customer identifier | Impute with session-based ID (rejected: unreliable) |
| Remove Quantity ≤ 0 | 10,624 | 1.96% | Data entry errors or adjustments | Cap at minimum 1 (rejected: arbitrary) |

### Process

1. Understand the data
    - source reports no missing values for all columns, but there are 1,454 null Description values (0.27%) and 135,080 NULL CustomerID values (24.93%)
2. Clean/validate the data for customer analysis
    - removed rows with cancellations, null CustomerID, or negative Quantity
    - reduced table from 541,909 rows to 408,548 (-133,361 rows)
3. Measure customer revenue
4. Measure purchase frequency
5. Identify high-value customers
6. Segment customers
7. Look for geographic/product patterns
8. Test whether the patterns hold
9. Produce the numbers that support your final recommendation

### Tools Used
- DuckDB
- SQL

### Recommendations
None yet!

### How to set up

