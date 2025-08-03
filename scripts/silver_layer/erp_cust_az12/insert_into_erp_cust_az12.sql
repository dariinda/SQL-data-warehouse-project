









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
