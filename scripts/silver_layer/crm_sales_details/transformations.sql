select * from bronze.crm_sales_details;

-- checking for ord number
select sls_ord_num, count(sls_ord_num) from bronze.crm_sales_details group by sls_ord_num having count(sls_ord_num) >1


-- checking for invalid dates
select 
		nullif(sls_order_dt,0) sls_ord_dt
from bronze.crm_sales_details
where sls_order_dt<=0
or sls_order_dt = null
or len(sls_order_dt) != 8
or sls_order_dt < 19000101
or sls_order_dt > 20500101

-- checking for dates which are in order_dt > ship or due date
select * from bronze.crm_sales_details where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt;


-- calculations sales = quantity * price
select distinct
		sls_sales as old_sales, sls_quantity, sls_price as old_price,
		case 
			when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price )
			then sls_quantity * sls_price
			else sls_sales
		end as new_sales,
		case 
			when sls_price<=0 or sls_price is null
			then sls_sales/NULLIF(sls_quantity,0)
			else sls_price
		end as new_price
from bronze.crm_sales_details
where sls_sales != sls_quantity*sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <=0 or sls_quantity <=0 or sls_price <=0
   -- what rules should apply to deal with this issue
	  -- if sales is 0, null, -ve then derive it using quantity and price
	  -- if price is 0, null, -ve then derive it using quantity and sales
	  -- if price is -ve, convert it to +ve
