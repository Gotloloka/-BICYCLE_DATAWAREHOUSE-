DROP TABLE IF EXISTS gold.business_report ;
SELECT * INTO gold.business_report FROM (
SELECT DISTINCT
	i.order_id,
	i.item_id,
	p.product_id,
	o.customer_fullname,
	o.customer_email,
	o.Customer_address,
	o.staff_fullname,
	o.staff_email,
	o.staff_phone_number,
	o.store_name,
	o.store_email,
	o.store_phone_number,
	o.store_address,
	p.brand_name,
	p.product_name,
	p.category_name,
	p.gender_based,
	p.model_year,
	p.list_price,	
	o.order_date,
	DATEPART(DAY,o.order_date) AS order_day,
	DATENAME(weekday, o.order_date) AS order_dayname,
	CONCAT('Q',DATEPART(quarter, o.order_date)) AS order_quarter,
	DATENAME(MONTH,o.order_date) AS order_month,
	DATEPART(YEAR,o.order_date) AS  order_year,
	o.require_date,
	DATEPART(DAY,o.require_date) AS required_day,
	DATENAME(weekday, o.require_date) AS requires_dayname,
	CONCAT('Q',DATEPART(quarter, o.require_date)) AS required_quarter,
	DATENAME(MONTH,o.require_date) AS required_month, 
	DATEPART(YEAR,o.require_date) AS required_year,
	CASE WHEN o.shipped_date IS NULL THEN o.require_date
	ELSE o.shipped_date
	END shipped_date,
	CASE WHEN o.shipped_date IS NULL THEN DATEPART(DAY,o.require_date)
	ELSE DATEPART(DAY,o.shipped_date)
	END shipped_day,
	CASE WHEN o.shipped_date IS NULL THEN DATENAME(weekday,o.require_date)
	ELSE DATENAME(weekday,o.shipped_date)
	END shipped_dayname,
	CASE WHEN o.shipped_date IS NULL THEN CONCAT('Q',DATEPART(QUARTER,o.require_date))
	ELSE CONCAT('Q',DATEPART(QUARTER,o.shipped_date))
	END shipped_quarter,
	CASE WHEN o.shipped_date IS NULL THEN DATENAME(MONTH,o.require_date)
	ELSE DATENAME(MONTH,o.shipped_date)
	END shipped_month,
	CASE WHEN o.shipped_date IS NULL THEN DATEPART(YEAR,o.require_date)
	ELSE DATEPART(YEAR,o.shipped_date)
	END shipped_year,
	CASE WHEN DATEDIFF(DAY,o.shipped_date,o.require_date) < 0 THEN 'Late'
	ELSE 'On_time'
	END delivery_time,
	SUM(p.quantity)  OVER( PARTITION BY i.order_id,i.item_id, o.customer_fullname, o.staff_fullname, o.store_name, p.product_name, 
		p.category_name, p.gender_based, p.model_year, p.list_price, o.order_date, 
		o.require_date, o.shipped_date ) AS stock_qty,
	SUM(p.stock_amount) OVER (PARTITION BY i.order_id,i.item_id, o.customer_fullname, o.staff_fullname, o.store_name, p.product_name, 
		p.category_name, p.gender_based, p.model_year, p.list_price, o.order_date, 
		o.require_date, o.shipped_date) as stock_amount,

	SUM(i.quantity) OVER( PARTITION BY i.order_id,i.item_id, o.customer_fullname, o.staff_fullname, o.store_name, p.product_name, 
		p.category_name, p.gender_based, p.model_year, p.list_price, o.order_date, 
		o.require_date, o.shipped_date ) AS sold_qty,
		i.discount,
	SUM(i.sales_amount) OVER (PARTITION BY i.order_id,i.item_id, o.customer_fullname, o.staff_fullname, o.store_name, p.product_name, 
		p.category_name, p.gender_based, p.model_year, p.list_price, o.order_date, 
		o.require_date, o.shipped_date) AS sales_amount,
	SUM(i.discount_amount) OVER( PARTITION BY i.order_id,i.item_id, o.customer_fullname, o.staff_fullname, o.store_name, p.product_name, 
		p.category_name, p.gender_based, p.model_year, p.list_price, o.order_date, 
		o.require_date, o.shipped_date) as discount_amount,
	SUM(i.sales_amount) OVER (PARTITION BY i.order_id,i.item_id, o.customer_fullname, o.staff_fullname, o.store_name, p.product_name, 
		p.category_name, p.gender_based, p.model_year, p.list_price, o.order_date, 
		o.require_date, o.shipped_date) -
	SUM(i.discount_amount) OVER( PARTITION BY i.order_id,i.item_id, o.customer_fullname, o.staff_fullname, o.store_name, p.product_name, 
		p.category_name, p.gender_based, p.model_year, p.list_price, o.order_date, 
		o.require_date, o.shipped_date)  AS revenue_loss


FROM gold.fact_order_items i
LEFT JOIN gold.dim_products p
ON i.product_id = p.product_id
LEFT JOIN gold.dim_orders o
ON o.order_id = i.order_id
) h;
