/*
========================================================================================================
Staff Report
========================================================================================================
Purpose:
	- This report consolidated key staff metrics and behaviors 

	Highlights:
		1. Gathers essential fields as names,and transaction detials ,and
		
		2.  Agggregates staff-level metrics:
			- Segments staff  into categoties (low-performer, medium-performer , High-performer).
			- Total quantity sold 
			- Total sold amount 
			- Total loss amount
			- Total sold products 

========================================================================================================
*/
/*
--------------------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables 
-------------------------------------------------------------------------------------------------------- */
CREATE VIEW gold.staff_report AS 
WITH base_query AS (
SELECT 
 s.staff_fullname,
 s.staff_email,
 s.store_name,
 s.brand_name,
 s.category_name,
 s.gender_based,
 s.model_year,
 s.order_date,
 s.order_day,
 s.order_month,
 s.order_year,
 s.order_quarter,
 s.list_price,
 s.stock_amount,
 s.sold_qty,
 s.sales_amount,
 s.revenue_loss

FROM gold.business_report s),
/*
--------------------------------------------------------------------------------------------------------
2) Customer_aggregation: Summarizes key  metrics at the customer level
-------------------------------------------------------------------------------------------------------- */
staff_aggregation AS (
SELECT 
	ROW_NUMBER() OVER ( ORDER BY staff_fullname, order_year) AS staff_key, -- Introduce the surrogate key
	b.staff_fullname,
	b.store_name,

	
	b.order_quarter,
	b.order_month,

	b.order_year,

	ROUND(SUM(b.revenue_loss) OVER (PARTITION BY staff_fullName,order_year, order_month),2) AS monthly_revenue_loss ,
	ROUND(SUM(b.stock_amount) OVER(PARTITION BY staff_fullName,order_year, order_month),2) AS monthly_stock_amount,
	ROUND(SUM(b.sales_amount) OVER( PARTITION BY staff_fullname,order_year,order_month),2) as monthly_sales_amount,

	ROUND(SUM(b.revenue_loss) OVER (PARTITION BY staff_fullName,order_year,order_quarter),2) AS quarterly_revenue_loss ,
	ROUND(SUM(b.stock_amount) OVER(PARTITION BY staff_fullName,order_year, order_quarter),2) AS quaterly_stock_amount,
	ROUND(SUM(b.sales_amount) OVER( PARTITION BY staff_fullname,order_year, order_quarter),2) as quarterly_sales_amount,

	ROUND(SUM(b.revenue_loss) OVER (PARTITION BY staff_fullName,order_year),2) AS yearly_revenue_loss ,
	ROUND(SUM(b.stock_amount) OVER(PARTITION BY staff_fullName,order_year),2) AS yearly_stock_amount,
	ROUND(SUM(b.sales_amount) OVER( PARTITION BY staff_fullname,order_year),2) as yearly_sales_amount,
                                                     
	SUM(b.sold_qty) OVER( PARTITION BY staff_fullname, order_year, order_month) AS monthly_sold_qty,
	SUM(b.sold_qty) OVER( PARTITION BY staff_fullname, order_year, order_quarter) AS quarterly_sold_qty,
	SUM(b.sold_qty) OVER( PARTITION BY staff_fullname, order_year) AS yearly_sold_qty,


	CASE WHEN SUM(b.sales_amount) OVER( PARTITION BY staff_fullname,order_year, order_month) > 200000 THEN 'High'
		 WHEN SUM(b.sales_amount) OVER( PARTITION BY staff_fullname,order_year, order_month) between 100000 and 200000 THEN 'Medium'
		 ELSE 'Low'
	END monthly_performers,
		CASE WHEN SUM(b.sales_amount) OVER( PARTITION BY staff_fullname,order_year, order_quarter) > 1000000 THEN 'High'
		 WHEN SUM(b.sales_amount) OVER( PARTITION BY staff_fullname,order_year,order_quarter) between 500000 and 1000000 THEN 'Medium'
		 ELSE 'Low'
	END quarterly_performers,
	CASE WHEN SUM(b.sales_amount) OVER( PARTITION BY staff_fullname, order_year) > 3000000 THEN 'High'
		 WHEN SUM(b.sales_amount) OVER( PARTITION BY staff_fullname, order_year) between 2000000 and 3000000THEN 'Medium'
		 ELSE 'Low'
	END yearly_performers
FROM base_query b)

SELECT  DISTINCT
*
FROM staff_aggregation
