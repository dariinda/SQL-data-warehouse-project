

-- It has very good data quality 
-- no changes are made here

-- checking the data quality with quereies
-- check for unwanted space
select * 
from bronze.erp_px_cat_g1v2
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance) 

-- checking for standarization and consistency 
select distinct maintenance
from bronze.erp_px_cat_g1v2
