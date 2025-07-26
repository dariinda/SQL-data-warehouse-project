/*
----------------------------------------------------------------------------------
----------------------  Silver Layer Transformations -----------------------------
----------------------------------------------------------------------------------
This scripts deal with transformation of all the tables of bronze layer .
After transforming we can insert the data to the silver layer.

In silver layer we can also use the tranformations to check if it is working fine.


Transformations done :
1. Removing duplicates
2. Removing unwanted spaces
3. Data standardization and data consistency
4. Handling missing data
Note : Check the datatype of date always.
*/

SELECT * FROM bronze.crm_cust_info;

-- 1. checking for the duplicates and null values
--  expectation : no result
select cst_id, count(cst_id)
from bronze.crm_cust_info
group by cst_id
having count(cst_id) > 1 or cst_id is null
  

-- 2. checking for unwanted spaces 
-- if original value is not equal to value we got after trimming, 
-- it means there are spaces
-- we can do it for all the varchar columns
select cst_firstname
from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname)
-- 
select cst_lastname
from bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname)


-- data consistency and standardization
-- quality check
-- (in our data we should use meaingful values instead of abbrevations)
select distinct cst_gndr from bronze.crm_cust_info;
-- we also have to remove the null values with meaingful values
-- like 'n/a'
