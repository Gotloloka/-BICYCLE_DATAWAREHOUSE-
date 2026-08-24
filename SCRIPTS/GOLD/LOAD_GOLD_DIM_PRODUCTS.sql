SELECT * INTO gold.dim_products FROM (
SELECT	
	p.product_id,
	p.brand_id,
	p.category_id,
	s.store_id,
	b.brand_name,
	p.product_name,
	ca.category_name,
	p.gender_based,
	p.model_year,
	p.list_price,
	s.quantity,
	p.list_price*s.quantity AS stock_amount

FROM silver.products p
LEFT JOIN silver.brands b
ON p.brand_id = b.brand_id
LEFT JOIN silver.categories ca
ON p.category_id = ca.category_id
LEFT JOIN silver.stocks s
ON p.product_id = s.product_id) p
