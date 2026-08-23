CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @starttime DATETIME, @endtime DATETIME, @batchstarttime DATETIME,@batchendtime DATETIME;
	BEGIN TRY
		SET @batchstarttime = getdate();
		PRINT ' =============================================================================='
		PRINT ' SILVER LAYER STARTED : LOADING DATA and CREATING TABLES'
		PRINT ' =============================================================================='
		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.brands)if already created '
		DROP TABLE IF EXISTS silver.brands;
		PRINT ' New table (silver.brands) is created and data is loaded'
		SELECT * INTO silver.brands FROM (
		SELECT 
			b.brand_id,
			b.brand_name
		FROM bronze.brands b) b; 
		PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.categories)if already created '
		DROP TABLE IF EXISTS silver.categories;
		PRINT ' New table (silver.categories) is created and data is loaded'
		SELECT * INTO silver.categories FROM (
		SELECT 
			ct.category_id,
			ct.category_name
		FROM bronze.categories ct) ct;
		SET @endtime =  GETDATE();
		PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.staffs)if already created '
		DROP TABLE IF EXISTS silver.staffs;
		PRINT ' New table (silver.staffs) is created and data is loaded'
		SELECT * INTO silver.staffs FROM (
		SELECT 
		 sf.staff_id,
		 sf.manager_id,
		 sf.store_id,
		 CONCAT(sf.first_name,' ',sf.last_name) full_name,
		 sf.email,
		 sf.phone,
		 sf.active
		FROM bronze.staffs sf) sf;
		SET @endtime =  GETDATE();
		PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.stores )if already created '
		DROP TABLE IF EXISTS silver.stores ;
		PRINT ' New table (silver.stores ) is created and data is loaded'
		SELECT * INTO silver.stores FROM (
			SELECT 
		 l.store_id,
		 l.store_name,
		 l.phone,
		 l.email,
		 l.street,
		 l.city,
		 l.states,
		 l.zip_code
		FROM bronze.stores l
		) l
		;
		SET @endtime =  GETDATE();
		PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.orders)if already created '
		DROP TABLE IF EXISTS silver.orders;
		PRINT ' New table (silver.orders) is created and data is loaded'
		SELECT * INTO silver.orders FROM(
		SELECT 
			o.order_id,
			o.customer_id,
			o.store_id,
			o.staff_id,
			o.order_date,
			o.require_date,
			CASE WHEN o.shippped_date = 'null' then Null
			ELSE o.shippped_date
			END shipped_date
		FROM bronze.orders o) o;
		SET @endtime =  GETDATE();
		PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.order_items)if already created '
		DROP TABLE IF EXISTS silver.order_items;
		PRINT ' New table (silver.order_items) is created and data is loaded'
		SELECT * INTO silver.order_items FROM (
		SELECT
			i.order_id,
			i.item_id,
			i.product_id,
			i.quantity,
			i.list_price,
			i.discount
		FROM bronze.order_items i) i;
		SET @endtime =  GETDATE();
		PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.products)if already created '
		DROP TABLE IF EXISTS silver.products;
		PRINT ' New table (silver.products is created and data is loaded'
		SELECT * INTO silver.products FROM (
		SELECT 
			p.product_id,
			p.brand_id,
			p.category_id,
			SUBSTRING(p.product_name,0, CHARINDEX('-',p.product_name)) as product_name,
			CASE WHEN  p.product_name like '%women%' or p.product_name like '%ladies%' THEN 'Women Bicycle'
			ElSE 'Neutral Bicycle'
			END gender_based,
			p.model_year,
			p.list_price
		FROM bronze.products p) p
		;
		SET @endtime =  GETDATE();
		PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.stocks)if already created '
		DROP TABLE IF EXISTS silver.stocks;
		PRINT ' New table (silver.stocks) is created and data is loaded'
		SELECT * INTO silver.stocks FROM (
		SELECT 
		 ss.store_id,
		 ss.product_id,
		 ss.quantity
		FROM bronze.stocks ss) ss;
		PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Deleting table (silver.customers)if already created '
		DROP TABLE IF EXISTS silver.customers;
		PRINT ' New table (silver.customers) is created and data is loaded'
		SELECT * INTO silver.customers FROM(
		SELECT 
		 cu.customer_id,
		 CONCAT(cu.first_name,' ',cu.last_name) AS fullname,
		 CASE WHEN cu.phone = 'Null' Then Null
		 ElSE cu.phone
		 END phone,
		 cu.email,
		 cu.street,
		 cu.city,
		 cu.zip_code
		FROM bronze.customers cu) cu;
			SET @endtime =  GETDATE();
			PRINT '	- Total Load Duration: ' + CAST( DATEDIFF(SECOND,@starttime,@endtime) as NVARCHAR)+'seconds';
			PRINT '-----------------------------------------------------------------------------' ;
			PRINT'    ' 
			PRINT ' =============================================================================='
			PRINT '  SILVER LAYER HAS COMPLETED : LAODING DATA and CREATING TABLES'
			PRINT ' ==============================================================================';
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
END


