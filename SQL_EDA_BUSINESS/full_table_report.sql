CREATE VIEW eda_full_report AS 
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
	o.require_date,
	o.shipped_date,
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
		o.require_date, o.shipped_date) as discount_amount

FROM gold.fact_order_items i
LEFT JOIN gold.dim_products p
ON i.product_id = p.product_id
LEFT JOIN gold.dim_orders o
ON o.order_id = i.order_id
