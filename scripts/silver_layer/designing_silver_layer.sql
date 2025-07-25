/*
----------------------------------------------------------------------------------
------------------------------  Silver Layer DDL ---------------------------------
----------------------------------------------------------------------------------
This scripts create or define all the tables of silver layer.
Creates table for both :
- CRM 
- ERP

what i did
- We can copy this structure from the bronze layer as we have to use the same but with transformations

small change here :
- we have split the prd_key columns into 2 columns for simplicity 

NOTE : UPDATE THE INFO HERE IN CREATION OF TABLE crm_prd_info
*/


IF OBJECT_ID ('silver.crm_cust_info','U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

GO 

IF OBJECT_ID ('silver.crm_prd_info','U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id VARCHAR(50), -- Splitted column from prd_key
	prd_key VARCHAR(50), -- Splitted column from prd_key
	prd_nm VARCHAR(50),
	prd_cost INT, 
	prd_line VARCHAR(50),
	prd_start_dt DATETIME, 
	prd_end_dt DATETIME,
	dwh_create_date DATETIME2 DEFAULT GETDATE()

)

GO


IF OBJECT_ID ('silver.crm_sales_details','U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()

)

GO

IF OBJECT_ID ('silver.erp_loc_a101','U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101(
	cid VARCHAR(50),
	cntry VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()

)

GO

IF OBJECT_ID ('silver.erp_cust_az12','U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12(
	cid VARCHAR(50), 
	bdate DATE, 
	gen VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()

)

GO

IF OBJECT_ID ('silver.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
	id VARCHAR(50), 
	cat VARCHAR(50), 
	subcat VARCHAR(50), 
	maintenance VARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()

)
