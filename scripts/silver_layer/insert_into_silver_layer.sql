/*
----------------------------------------------------------------------------------
-------------------------- Silver Layer Bulk loading -----------------------------
----------------------------------------------------------------------------------

-- After checking the transformations
-- applying them and bulk loading in the silver layer

*/

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
