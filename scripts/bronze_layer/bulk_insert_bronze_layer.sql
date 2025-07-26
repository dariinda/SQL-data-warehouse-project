/*
----------------------------------------------------------------------------------
--------------------------- BULK INSERT Bronze Layer  ----------------------------
----------------------------------------------------------------------------------
- Created procedure to insert data in Bronze layer
- Calculated the time for each insert in table
- Calculated the time for whole batch insert
- Error handling is also done

- Added execute command at the last. 
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @begin_time DATETIME, @finish_time DATETIME
	BEGIN TRY

		SET @begin_time  = GETDATE();

		PRINT '----------------------------------------------------------------------------'
		PRINT '----------------------- LOADING BRONZE LAYER -------------------------------'
		PRINT '----------------------------------------------------------------------------'


		PRINT 'Loading CRM tables'
		PRINT '------------------'

-- cust info
		SET @start_time = GETDATE();
		PRINT 'Truncating cust_info table'
		TRUNCATE TABLE bronze.crm_cust_info
		PRINT 'Loading cust_info table'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Acer\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'

-- prod info
		SET @start_time = GETDATE();
		PRINT 'Truncating prd_info table'
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT 'Loading prd_info table'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Acer\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'

-- sales info
		SET @start_time = GETDATE();
		PRINT 'Truncating sales_details table'
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT 'Loading sales_details table'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Acer\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'


		
		PRINT 'Loading ERP tables'
		PRINT '------------------'

-- cust az 
		SET @start_time = GETDATE();
		PRINT 'Truncating cust_az12 table'
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT 'Loading cust_az12 table'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Acer\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'

-- loc a101
		SET @start_time = GETDATE();
		PRINT 'Truncating loc_a101 table'
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT 'Loading loc_a101 table'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Acer\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'

-- cat table
		SET @start_time = GETDATE();
		PRINT 'Truncating px_cat_g1v2 table'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		PRINT 'Loading erp_px_cat_g1v2 table'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Acer\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'

		SET @finish_time = GETDATE();
		PRINT ' --------------------------------------------------------------------------------------------'
		PRINT ' Bronze layer successfully updated'
		PRINT ' Total duration : '+ CAST(DATEDIFF(second, @begin_time, @finish_time)AS VARCHAR) + ' seconds.'
		PRINT ' --------------------------------------------------------------------------------------------'

	END TRY
	BEGIN CATCH
		PRINT ' ********************************************************************************************'
		PRINT ' ERROR :: There was an error while updating broze layer'
		PRINT ' ERROR MESSAGE : ' + ERROR_MESSAGE();
		PRINT ' ERROR MESSAGE : ' + CAST(ERROR_MESSAGE() AS VARCHAR)
		PRINT ' ********************************************************************************************'


	END CATCH
END;

EXEC bronze.load_bronze


