/*
1. when run this script please note that it was run from my local computer.
2. Download the dataset from this GitHub to your local machine 
3. on  your computer copy the location path of the file 
4. update the SCRIPT path on FROM 'c\....' to the one copied from your computer.
5. update all the file path location on this SCRIPT
6. Run script!!!
7. Any ERROR FOUND DURING running of this script contact me */

CREATE PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @starttime DATETIME, @endtime DATETIME, @batchstarttime DATETIME, @batchendtime DATETIME;
	BEGIN TRY
		SET @batchstarttime = getdate();
		PRINT ' =============================================================================='
		PRINT ' LOADING BRONZE LAYER STARTED'
		PRINT ' =============================================================================='
		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Clearing off/ truncate any visible data on bronze.brands';
		TRUNCATE TABLE bronze.brands;
		PRINT ' loading data into bronze.brands table';
		BULK INSERT bronze.brands 
		FROM 'C:\Users\user\Downloads\file\brands.csv'
		WITH (
			format = 'csv',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			TABLOCK
		);
		SET @endtime =  GETDATE();
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Clearing off/ truncate any visible data on bronze.categories';
		TRUNCATE TABLE bronze.categories;
		PRINT ' loading data into bronze.categories table';
		BULK INSERT bronze.categories 
		FROM 'C:\Users\user\Downloads\file\categories.csv'
		WITH (
			format = 'csv',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			TABLOCK
		);
		SET @endtime =  GETDATE();
		PRINT '-----------------------------------------------------------------------------';

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Clearing off/ truncate any visible data on bronze.customers';
		TRUNCATE TABLE bronze.customers;
		PRINT ' loading data into bronze.customers table';
		BULK INSERT bronze.customers
		FROM 'C:\Users\user\Downloads\file\customers.csv'
		WITH (
			format = 'csv',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			TABLOCK,
			keepnulls
		);
		SET @endtime =  GETDATE();
		PRINT '-----------------------------------------------------------------------------'  ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Clearing off/ truncate any visible data on bronze.order_items';
		TRUNCATE TABLE bronze.order_items;
		PRINT ' loading data into bronze.order_items table';
		BULK INSERT bronze.order_items
		FROM 'C:\Users\user\Downloads\file\order_items.csv'
		WITH (
			format = 'csv',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			TABLOCK
		);
		SET @endtime =  GETDATE();
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Clearing off/ truncate any visible data on bronze.orders';
		TRUNCATE TABLE bronze.orders;
		PRINT ' loading data into bronze.orders table';
		BULK INSERT bronze.orders
		FROM 'C:\Users\user\Downloads\file\orders.csv'
		WITH (
			format = 'csv',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			TABLOCK
		);
		SET @endtime =  GETDATE();
		PRINT '-----------------------------------------------------------------------------';
		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Clearing off/ truncate any visible data on bronze.stocks';
		TRUNCATE TABLE bronze.stocks;
		PRINT ' loading data into bronze.stocks table';
		BULK INSERT bronze.stocks
		FROM 'C:\Users\user\Downloads\file\stocks.csv'
		WITH (
			format = 'csv',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			TABLOCK
		);
		SET @endtime =  GETDATE();
		PRINT '-----------------------------------------------------------------------------';

		PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Clearing off/ truncate any visible data on bronze.stores';
		TRUNCATE TABLE bronze.stores;
		PRINT ' loading data into bronze.stores table';
		BULK INSERT bronze.stores
		FROM 'C:\Users\user\Downloads\file\stores.csv'
		WITH (
			format = 'csv',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			TABLOCK
		);
		SET @endtime =  GETDATE();

		PRINT '-----------------------------------------------------------------------------' ;
			PRINT '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' 
		SET @starttime = GETDATE();
		PRINT ' Clearing off/ truncate any visible data on bronze.staffs';
		TRUNCATE TABLE bronze.staffs;
		PRINT ' loading data into bronze.staffs';
		BULK INSERT bronze.staffs
		FROM 'C:\Users\user\Downloads\file\staffs.csv'
		WITH (
			format = 'csv',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FIRSTROW = 2,
			TABLOCK
		);
		SET @endtime =  GETDATE();
		PRINT '-----------------------------------------------------------------------------' ;

		PRINT ' =============================================================================='
		PRINT ' LOADING BRONZE LAYER HAS COMPLETED'
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

