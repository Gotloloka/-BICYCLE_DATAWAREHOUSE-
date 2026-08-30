/*
========================================================================================================
Customer Report
========================================================================================================
Purpose:
	- This report consolidated key customer metrics and behaviors 

	Highlights:
		1. Gathers essential fields as names,and transaction detials ,and
		 Segments customer into categoties (V-VIP, VIP, Regular, New) and age groups.
		2.  Agggregates customer -level metrics:
			- total quantity bought per category 
			- total spent amount 
			- total saved amount
			- total products 

========================================================================================================
*/
/*
--------------------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables 
-------------------------------------------------------------------------------------------------------- */
CREATE VIEW gold.customer_reprot AS 
WITH base_query AS (
SELECT 
	c.customer_fullname,
	c.brand_name,
	c.category_name,
	c.gender_based,
	c.model_year,
	c.order_date,
	c.require_date,
	c.shipped_date,
	c.delivery_time,
	c.sold_qty AS bought_qty,
	c.sales_amount,
	c.discount_amount,
	c.revenue_loss as saved_amount,
	SUM( c.sales_amount) OVER ( PARTITION BY c.customer_fullname) AS customer_spend,
	CASE  when sum( c.sales_amount) OVER ( PARTITION BY c.customer_fullname) > 50000 THEN 'V-VIP'
	WHEN SUM( c.sales_amount) OVER ( PARTITION BY c.customer_fullname) between 25000 and 50000 THEN 'VIP'
		 WHEN COUNT(c.customer_fullname) OVER ( PARTITION BY c.customer_fullname) > 2 THEN 'Regular'
		 ELSE 'New'
	END customer_segment
FROM gold.business_report c),
/*
--------------------------------------------------------------------------------------------------------
2) Customer_aggregation: Summarizes key  metrics at the customer level
-------------------------------------------------------------------------------------------------------- */
customer_aggregation AS (
SELECT 
	customer_fullname,
	brand_name,
	category_name,
	gender_based,
	model_year,
	delivery_time,
	customer_segment,
	order_date,
	require_date,
	shipped_date,
	discount_amount,
	sales_amount,
	RANK() OVER( PARTITION BY customer_fullname ORDER BY sales_amount) rank_sales,
	saved_amount,
	customer_spend,
	SUM( bought_qty) OVER( PARTITION BY customer_fullname, category_name) AS total_quantity_bought ,
	SUM( discount_amount) OVER( PARTITION BY customer_fullname, category_name) AS total_spend_amount,
	SUM( saved_amount) OVER( PARTITION BY customer_fullname, category_name) AS total_saved_amount,
	SUM( bought_qty) OVER( PARTITION BY customer_fullname)  AS total_products
FROM base_query)

