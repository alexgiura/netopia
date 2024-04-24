-- name: GetActualVsLastYearSales :many
SELECT month::text, amount_this_year::float, amount_last_year::float  FROM core.get_sales_actual_vs_last();
