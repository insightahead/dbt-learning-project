{% docs customer_total_return %}

## TPC-DS Query 1

**Objective:**  
Find customers who have returned items more than 20% more often than the average customer returns for a store in a given state for a given year.

**Qualification Substitution Parameters:**  
- `YEAR.01`: 2000
- `STATE.01`: TN
- `AGG_FIELD.01`: SR_RETURN_AMT
{% enddocs %}

{% docs weekly_sales_year_over_year_comparison %}

## TPC-DS Query 2

**Objective:**  
Report the ratios of weekly web and catalog sales increases from one year to the next year for each week. That is, compute the increase of Monday, Tuesday, ... Sunday sales from one year to the following.

**Qualification Substitution Parameters:**  
- `YEAR.01`: 2001

{% enddocs %}