/*
----------------------------------------------------------------------------------
--------------------------- INSERT into SILVER Layer  ----------------------------
----------------------------------------------------------------------------------
- Created procedure to insert data in Silver layer
- Calculated the time for each insert in table
- Calculated the time for whole batch insert
- Error handling is also done

- Added execute command at the last. 
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @begin_time DATETIME, @finish_time DATETIME
	BEGIN TRY

		SET @begin_time  = GETDATE();

		PRINT '----------------------------------------------------------------------------'
		PRINT '----------------------- LOADING SILVER LAYER -------------------------------'
		PRINT '----------------------------------------------------------------------------'


		PRINT 'Loading CRM tables'
		PRINT '------------------'

-- cust info
		SET @start_time = GETDATE();
		PRINT '>> Truncating the table : silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Inserting data into table : silver.crm_cust_info'
		
		INSERT INTO silver.crm_cust_info(
			cst_id, 
			cst_key, 
			cst_firstname, 
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		select 
			cst_id, 
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,  
			TRIM(cst_lastname) AS cst_lastname,
			CASE 
				WHEN cst_marital_status = UPPER(TRIM('S')) THEN 'Single'
				WHEN cst_marital_status = UPPER(TRIM('M')) THEN 'Married'
				ELSE 'N/A'
			END cst_marital_status,
			CASE 
				WHEN cst_gndr = UPPER(TRIM('F')) THEN 'Female'
				WHEN cst_gndr = UPPER(TRIM('M')) THEN 'Male'
				ELSE 'N/A'
			END cst_gndr,
			cst_create_date
		from (select *, ROW_NUMBER() OVER (partition by cst_id order by cst_create_date desc) as flag_last
		from bronze.crm_cust_info) t
		where flag_last = 1

		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'
		
		
--crm_prd_info 
		SET @start_time = GETDATE();
		PRINT '>> Truncating the table : silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Inserting data into table : silver.crm_prd_info'
		
		insert into silver.crm_prd_info(
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		select
			prd_id,
			replace(substring(prd_key, 1,5),'-','_') as cat_id,
			substring(prd_key, 7, len(prd_key)) as prd_key,
			prd_nm,
			coalesce(prd_cost , 0) as prd_cost,
			case
				when upper(trim(prd_line)) = 'M' then 'Mountain'
				when upper(trim(prd_line)) = 'R' then 'Road'
				when upper(trim(prd_line)) = 'S' then 'Other sales'
				when upper(trim(prd_line)) = 'T' then 'Touring'
				else 'N/A'
			end as prd_line,
			cast (prd_start_dt as date) as prd_start_dt,
			cast (lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt
		from bronze.crm_prd_info
		
		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'
		
		
-- crm_sales_details 
		SET @start_time = GETDATE();
		PRINT '>> Truncating the table : silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting data into table : silver.sales_details'
		
		INSERT INTO silver.crm_sales_details (
			sls_ord_num ,
			sls_prd_key ,
			sls_cust_id ,
			sls_order_dt ,
			sls_ship_dt ,
			sls_due_dt ,
			sls_sales,
			sls_quantity ,
			sls_price 
		)
		select 
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				case 
					when sls_order_dt<=0 or len(sls_order_dt) != 8 then null
					else cast(cast(sls_order_dt as varchar) as date)
				end as sls_order_dt,
				case 
					when sls_ship_dt<=0 or len(sls_ship_dt) != 8 then null
					else cast(cast(sls_ship_dt as varchar) as date)
				end as sls_ship_dt,
				case 
					when sls_due_dt<=0 or len(sls_due_dt) != 8 then null
					else cast(cast(sls_due_dt as varchar) as date)
				end as sls_due_dt,
				case 
					when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price )
					then sls_quantity * sls_price
					else sls_sales
				end as sls_sales,
				sls_quantity,
				case 
					when sls_price<=0 or sls_price is null
					then sls_sales/NULLIF(sls_quantity,0)
					else sls_price
				end as sls_price
		from bronze.crm_sales_details

		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'
		
		PRINT 'Loading ERP tables'
		PRINT '------------------'
			
-- erp_cust_az12 	
		SET @start_time = GETDATE();
		PRINT '>> Truncating the table : silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Inserting data into table : silver.erp_cust_az12'
		
		insert into silver.erp_cust_az12(
			cid, 
			bdate, 
			gen
		)
		select 
			case 
				when cid like 'NAS%' then substring(cid, 4, len(cid))
				else cid
			end as cid,
			case
				when bdate > GETDATE() then null
				else bdate
			end as bdate, --set future dates null
			case 
				when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
				when upper(trim(gen)) in ('M', 'MALE') then 'Male'
				else 'n/a'
			end as  gen
		from bronze.erp_cust_az12;

		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'
		
		
-- erp_loc_a101 
		SET @start_time = GETDATE();
		PRINT '>> Truncating the table : silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Inserting data into table : silver.erp_loc_a101'
		
		insert into silver.erp_loc_a101(
			cid, 
			cntry
		)
		select
			replace(cid, '-', '') cid,
			case
				when trim(cntry) = 'DE' then 'Denmark'
				when trim(cntry) in ('US', 'USA') then 'United States'
				when trim(cntry) = '' OR cntry is null then 'n/a'
				else trim(cntry)
			end as cntry
		from bronze.erp_loc_a101
		SET @end_time = GETDATE();
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'
		
-- erp_px_cat_g1v2 
		SET @start_time = GETDATE();
		PRINT '>> Truncating the table : silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Inserting data into table : silver.erp_px_cat_g1v2'
		
		insert into silver.erp_px_cat_g1v2(
			id,
			cat, 
			subcat, 
			maintenance
		)
		select * from bronze.erp_px_cat_g1v2
		PRINT 'Load duration : '+CAST(DATEDIFF(second, @start_time, @end_time) AS VARCHAR) + 'seconds.'

		SET @finish_time = GETDATE();
		PRINT ' --------------------------------------------------------------------------------------------'
		PRINT ' Silver layer successfully updated'
		PRINT ' Total duration : '+ CAST(DATEDIFF(second, @begin_time, @finish_time)AS VARCHAR) + ' seconds.'
		PRINT ' --------------------------------------------------------------------------------------------'

	END TRY
	BEGIN CATCH
		PRINT ' ********************************************************************************************'
		PRINT ' ERROR :: There was an error while updating Silver layer'
		PRINT ' ERROR MESSAGE : ' + ERROR_MESSAGE();
		PRINT ' ERROR MESSAGE : ' + CAST(ERROR_MESSAGE() AS VARCHAR)
		PRINT ' ********************************************************************************************'
	END CATCH
END

EXEC silver.load_silver
