--Q01. Executive KPI baseline.
--Business question: What is the scale of positive-value sales activity?
--Interpretation: revenue is sum(quantity * unit_price) for positive quantity and price.
--Missing customer IDs are included in sales-line revenue but not distinct identified customers.
*/
SELECT
    COUNT(*) AS sales_line_count,
    COUNT(DISTINCT invoice_no) AS invoice_count,
    COUNT(DISTINCT customer_id) AS identified_customer_count,
    ROUND(SUM(quantity * unit_price), 2) AS gross_positive_line_revenue,
    ROUND(AVG(quantity * unit_price), 2) AS average_sales_line_value
FROM online_retail_clean
WHERE quantity > 0
  AND unit_price > 0;


-- Q02. Monthly sales trend.
--Business question: How do sales and order volumes change month by month?

WITH sales AS (
    SELECT
        DATE_TRUNC('month', TO_TIMESTAMP(invoice_date, 'MM/DD/YYYY HH24:MI'))::DATE AS sales_month,
        invoice_no,
        quantity * unit_price AS line_revenue
    FROM online_retail_clean
    WHERE quantity > 0
      AND unit_price > 0
)
SELECT
    sales_month,
    COUNT(*) AS sales_lines,
    COUNT(DISTINCT invoice_no) AS invoices,
    ROUND(SUM(line_revenue), 2) AS gross_positive_line_revenue
FROM sales
GROUP BY sales_month
ORDER BY sales_month;

--Q03. Top products by revenue.
--Business question: Which products contribute the most positive-value revenue?
--Note: description can be missing; stock_code is retained as the product identifier.
*/
SELECT
    stock_code,
    COALESCE(NULLIF(BTRIM(description), ''), '(Missing description)') AS product_description,
    SUM(quantity) AS units_sold,
    COUNT(DISTINCT invoice_no) AS invoice_count,
    ROUND(SUM(quantity * unit_price), 2) AS gross_positive_line_revenue
FROM online_retail_clean
WHERE quantity > 0
  AND unit_price > 0
GROUP BY stock_code, COALESCE(NULLIF(BTRIM(description), ''), '(Missing description)')
ORDER BY gross_positive_line_revenue DESC
LIMIT 20;

/* Q04. Country performance.
Business question: Which countries contribute the most sales value and volume?
*/
SELECT
    country,
    COUNT(DISTINCT invoice_no) AS invoice_count,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS gross_positive_line_revenue,
    ROUND(
        100.0 * SUM(quantity * unit_price)
        / NULLIF(SUM(SUM(quantity * unit_price)) OVER (), 0),
        2
    ) AS revenue_share_pct
FROM online_retail_clean
WHERE quantity > 0
  AND unit_price > 0
GROUP BY country
ORDER BY gross_positive_line_revenue DESC;



/* Q05. Customer value ranking.
Business question: Which identified customers generate the highest positive-value revenue?
Caveat: customer IDs are missing on a substantial portion of rows, so this is not all sales.
*/
SELECT
    customer_id,
    COUNT(DISTINCT invoice_no) AS invoice_count,
    SUM(quantity) AS units_purchased,
    ROUND(SUM(quantity * unit_price), 2) AS gross_positive_line_revenue,
    ROUND(AVG(quantity * unit_price), 2) AS average_line_value
FROM online_retail_clean
WHERE quantity > 0
  AND unit_price > 0
  AND NULLIF(BTRIM(customer_id), '') IS NOT NULL
GROUP BY customer_id
ORDER BY gross_positive_line_revenue DESC
LIMIT 20;

/* Q06. Cancellation-prefixed invoice analysis.
Business question: How many rows and what recorded value are associated with C-prefixed invoices?
Caveat: negative quantities and zero-price operational records may not all be customer returns.
*/
SELECT
    COUNT(*) AS cancellation_prefixed_rows,
    COUNT(DISTINCT invoice_no) AS cancellation_prefixed_invoice_count,
    COUNT(*) FILTER (WHERE quantity < 0) AS negative_quantity_rows,
    COUNT(*) FILTER (WHERE unit_price = 0) AS zero_price_rows,
    ROUND(SUM(quantity * unit_price), 2) AS recorded_line_value
FROM online_retail_clean
WHERE invoice_no ILIKE 'C%';


/* Q07. Negative-quantity rows without a C prefix.
Business question: How many potential adjustments/returns exist outside the C-prefix group?
*/
SELECT
    COUNT(*) AS negative_quantity_other_rows,
    COUNT(*) FILTER (WHERE unit_price = 0) AS zero_price_rows,
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(description), '') IS NULL) AS missing_description_rows,
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(customer_id), '') IS NULL) AS missing_customer_rows,
    ROUND(SUM(quantity * unit_price), 2) AS recorded_line_value
FROM online_retail_clean
WHERE quantity < 0
  AND invoice_no NOT ILIKE 'C%';



/* Q08. Hour-of-day sales pattern.
Business question: At what hours is positive-value sales activity highest?
*/
SELECT
    EXTRACT(HOUR FROM TO_TIMESTAMP(invoice_date, 'MM/DD/YYYY HH24:MI'))::INTEGER AS invoice_hour,
    COUNT(DISTINCT invoice_no) AS invoice_count,
    COUNT(*) AS sales_line_count,
    ROUND(SUM(quantity * unit_price), 2) AS gross_positive_line_revenue
FROM online_retail_clean
WHERE quantity > 0
  AND unit_price > 0
GROUP BY invoice_hour
ORDER BY invoice_hour;


/* Q09. Day-of-week performance.
Business question: Which weekdays have the most positive-value sales?
*/
SELECT
    TO_CHAR(TO_TIMESTAMP(invoice_date, 'MM/DD/YYYY HH24:MI'), 'Dy') AS weekday,
    EXTRACT(ISODOW FROM TO_TIMESTAMP(invoice_date, 'MM/DD/YYYY HH24:MI'))::INTEGER AS weekday_number,
    COUNT(DISTINCT invoice_no) AS invoice_count,
    ROUND(SUM(quantity * unit_price), 2) AS gross_positive_line_revenue
FROM online_retail_clean
WHERE quantity > 0
  AND unit_price > 0
GROUP BY weekday, weekday_number
ORDER BY weekday_number;


/* Q10. Average invoice value (identified invoice basket).
Business question: What is the average positive-value basket per invoice?
Method: first aggregate line values to invoice level, then average invoice totals.
*/
WITH invoice_totals AS (
    SELECT
        invoice_no,
        ROUND(SUM(quantity * unit_price), 2) AS invoice_value
    FROM online_retail_clean
    WHERE quantity > 0
      AND unit_price > 0
    GROUP BY invoice_no
)
SELECT
    COUNT(*) AS invoices,
    ROUND(AVG(invoice_value), 2) AS average_invoice_value,
    ROUND(MIN(invoice_value), 2) AS minimum_invoice_value,
    ROUND(MAX(invoice_value), 2) AS maximum_invoice_value,
    ROUND(SUM(invoice_value), 2) AS gross_positive_line_revenue
FROM invoice_totals;


/* Q11. Product-level negative quantity investigation.
Business question: Which products appear most often in negative-quantity rows?
Interpretation: investigation list only; not a definitive return-rate measure.
*/
SELECT
    stock_code,
    COALESCE(NULLIF(BTRIM(description), ''), '(Missing description)') AS product_description,
    COUNT(*) AS negative_quantity_rows,
    SUM(ABS(quantity)) AS absolute_negative_units,
    COUNT(DISTINCT invoice_no) AS affected_invoices,
    ROUND(SUM(quantity * unit_price), 2) AS recorded_negative_line_value
FROM online_retail_clean
WHERE quantity < 0
GROUP BY stock_code, COALESCE(NULLIF(BTRIM(description), ''), '(Missing description)')
ORDER BY absolute_negative_units DESC
LIMIT 20;


/* Q12. Data quality scorecard after view creation.
Business question: How much missingness remains in key descriptive fields?
Blank descriptions/customer IDs are normalized to NULL in the view.
*/
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(description), '') IS NULL) AS missing_description_rows,
    COUNT(*) FILTER (WHERE NULLIF(BTRIM(customer_id), '') IS NULL) AS missing_customer_id_rows,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS null_quantity_rows,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS null_unit_price_rows,
    COUNT(*) FILTER (WHERE transaction_group IS NULL) AS null_transaction_group_rows
FROM online_retail_clean;



/* Q13. Month-over-month revenue change.
Business question: Is gross positive line-item revenue growing or declining month over month?
First month has no prior month, so its percentage change is NULL.
*/
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', TO_TIMESTAMP(invoice_date, 'MM/DD/YYYY HH24:MI'))::DATE AS sales_month,
        SUM(quantity * unit_price) AS revenue
    FROM online_retail_clean
    WHERE quantity > 0
      AND unit_price > 0
    GROUP BY 1
),
comparison AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue) OVER (ORDER BY sales_month) AS previous_month_revenue
    FROM monthly
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS gross_positive_line_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(revenue - previous_month_revenue, 2) AS revenue_change,
    ROUND(
        100.0 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_change_pct
FROM comparison
ORDER BY sales_month;

/* Q14. Customer repeat-purchase summary.
Business question: How many identified customers placed one, two, or more invoices?
*/
WITH customer_invoice_counts AS (
    SELECT
        customer_id,
        COUNT(DISTINCT invoice_no) AS invoice_count
    FROM online_retail_clean
    WHERE quantity > 0
      AND unit_price > 0
      AND NULLIF(BTRIM(customer_id), '') IS NOT NULL
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN invoice_count = 1 THEN '1 invoice'
        WHEN invoice_count = 2 THEN '2 invoices'
        ELSE '3+ invoices'
    END AS purchase_frequency_group,
    COUNT(*) AS customer_count
FROM customer_invoice_counts
GROUP BY 1
ORDER BY MIN(invoice_count);


/* Q15. Invoice concentration / Pareto product contribution.
Business question: What share of positive-value revenue comes from the top 10 products?
Returns top 10 rows; Power BI can visualize the result as a bar chart.
*/
WITH product_revenue AS (
    SELECT
        stock_code,
        COALESCE(NULLIF(BTRIM(description), ''), '(Missing description)') AS product_description,
        SUM(quantity * unit_price) AS revenue
    FROM online_retail_clean
    WHERE quantity > 0
      AND unit_price > 0
    GROUP BY stock_code, COALESCE(NULLIF(BTRIM(description), ''), '(Missing description)')
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
        SUM(revenue) OVER () AS total_revenue
    FROM product_revenue
)
SELECT
    stock_code,
    product_description,
    ROUND(revenue, 2) AS gross_positive_line_revenue,
    revenue_rank,
    ROUND(100.0 * revenue / NULLIF(total_revenue, 0), 2) AS revenue_share_pct
FROM ranked
WHERE revenue_rank <= 10
ORDER BY revenue_rank, stock_code;


