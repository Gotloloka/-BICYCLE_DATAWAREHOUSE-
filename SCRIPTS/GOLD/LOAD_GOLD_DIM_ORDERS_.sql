SELECT * INTO gold.dim_orders FROM (
SELECT 
	o.order_id,
	c.customer_id,
	st.store_id,
	sf.staff_id,
	c.fullname AS customer_fullname,
	c.email AS customer_email,
	CONCAT(c.street,', ',c.city,', ',c.zip_code) AS Customer_address,
	sf.full_name AS staff_fullname,
	sf.email AS staff_email,
	sf.phone AS staff_phone_number,
	st.store_name,
	st.email AS store_email,
	st.phone AS store_phone_number,
	CONCAT( st.street,', ',st.city,', ',st.states,', ',st.zip_code) as store_address,
	o.order_date,
	o.require_date,
	o.shipped_date

FROM silver.orders o
LEFT JOIN silver.customers c
on o.customer_id = c.customer_id
LEFT JOIN silver.stores st
ON o.store_id = st.store_id
LEFT JOIN silver.staffs sf
ON o.staff_id =  sf.staff_id) o
