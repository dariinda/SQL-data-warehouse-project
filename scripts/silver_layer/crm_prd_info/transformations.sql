/*
----------------------------------------------------------------------------------
----------------------  Silver Layer Transformations -----------------------------
----------------------------------------------------------------------------------
This scripts deal with transformation of all the tables of bronze layer crm_prd_info.
After transforming we can insert the data to the crm_prd_info.

In silver layer we can also use the tranformations to check if it is working fine.

Transformations done :
1. Removing duplicates
2. Removing unwanted spaces
3. Data standardization and data consistency
4. Handling missing data
Note : Check the datatype of date always.
*/

-- checking the table values
select top(100) * from bronze.crm_prd_info;

-- checking duplicates and cheking nulls
select prd_id, count(prd_id)
from bronze.crm_prd_info 
group by prd_id 
having count(prd_id)>1 or prd_id is null;

-- unwanted spaces
select prd_nm
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm)

-- breaking prd_key into 2 columns 
-- broken keys are used as foreign key in other tables

-- check quality of the numbers in prd_cost
-- negative or null values
select * from bronze.crm_prd_info 
where prd_cost<0 or prd_cost is null

-- we have prd_line which has abbrevations 
-- change them with the meaingful names

-- check for invalid date orders
select * 
from bronze.crm_prd_info
where prd_start_dt > prd_end_dt;
-- solution : order them in asc and then 1st row's end date 
-- should be less than next row's start date
-- here we have to use window function lead
