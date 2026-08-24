/* 
==================================================================
Stored Procedure: Load GOLD Layer (SILVER ->)GOLD)
==================================================================
Script Purpose: 
	This stored loads data into the 'Gold' schema from silver schema.
	It performs the following actions:
	- it combine tables from the silver into one thing
Parameters:
	- JOINS statement
  - Views
 This stored procedure does not accpet any parameters or return any values.

Usage Example:
	EXEC gold.load_gold
==================================================================
*/
CREATE OR ALTER PROCEDURE gold.load_gold AS
BEGIN
DECLARE @starttime DATETIME, @endtime DATETIME, @batchstarttime DATETIME,@batchendtime DATETIME;
		PRINT ' =============================================================================='
		PRINT ' GOLD LAYER STARTED : LOADING DATA and CREATING DIM & FACT TABLE'
		PRINT ' =============================================================================='
BEGIN TRY
SET @batchstarttime = getdate();
SET @starttime = GETDATE();
DROP TABLE IF EXISTS gold.fact_order_items;
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
FROM silver.order_items i) i;
SET @endtime =  GETDATE();
PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
PRINT '-----------------------------------------------------------------------------' ;
PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
SET @starttime = GETDATE();
DROP TABLE IF EXISTS gold.dim_products;
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
ON p.product_id = s.product_id) p;
SET @endtime =  GETDATE();
PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
PRINT '-----------------------------------------------------------------------------' ;
PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
SET @starttime = GETDATE();
DROP TABLE IF EXISTS gold.dim_orders;
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
SET @endtime =  GETDATE();
PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
PRINT ' =============================================================================='
PRINT ' GOLD LAYER COMPLETED: LOADING DATA and CREATING DIM & FACT TABLE'
PRINT ' =============================================================================='
SET @batchendtime = GETDATE();
PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@batchstarttime,@batchendtime) as NVARCHAR)+'seconds';
END TRY
BEGIN CATCH
	PRINT ' =============================================================================='
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
	PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT 'ERROR_LINE: ' + CAST(ERROR_LINE() AS NVARCHAR)
	PRINT ' =============================================================================='	
END CATCH
END;
