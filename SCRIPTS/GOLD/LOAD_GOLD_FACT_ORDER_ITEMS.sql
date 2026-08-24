SELECT * INTO gold.fact_order_items FROM
(SELECT
	i.order_id,
	i.item_id,
	i.product_id,
	i.quantity,
	i.list_price,
	i.discount,
	i.quantity * i.list_price AS sales_amount,
	ROUND(i.quantity * i.list_price*(1-i.discount),2) as  discount_amount

FROM silver.order_items i) i
