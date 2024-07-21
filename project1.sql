---cau1---
alter table sales_dataset_rfm_prj
	alter ordernumber type int using (ordernumber::int),
	alter quantityordered type smallint using (quantityordered::smallint),
	alter priceeach type numeric using (priceeach::numeric),
	alter orderlinenumber type smallint using (orderlinenumber::smallint),
	alter sales type numeric using (sales::numeric),
	alter orderdate type timestamp without time zone using (orderdate::timestamp without time zone),
	alter status type text using(status::text),
	alter productline type text using (productline::text),
	alter msrp type smallint using (msrp::smallint),
	alter productcode type text using (productcode::text),
	alter customername type text using (customername::text),
	alter addressline1 type text using (addressline1 ::text),
	alter addressline2 type text using (addressline2::text),
	alter city type text  using (city::text)
---cau2---
select *
	from sales_dataset_rfm_prj
	where 
	ordernumber is null or
	quantityordered is null or 
	priceeach is null or 
	orderlinenumber is null or 
	sales is null or 
	orderdate is null 
---cau3--
select left(contactfullname,position ('-' in contactfullname)-1) as last_name,
substring(contactfullname,position ('-' in contactfullname)+1) as first_name
	from sales_dataset_rfm_prj)
---tạo bảng
	alter table sales_dataset_rfm_prj 
	add column last_name text,	
	add column first_name text 
---update
	update 	sales_dataset_rfm_prj
	set last_name = upper( left(contactfullname,1))||  
		substring(contactfullname,1,position ('-' in contactfullname)-2)
update sales_dataset_rfm_prj
	set first_name = upper(substring(contactfullname,position ('-' in contactfullname)+1,1))|| 
		substring(contactfullname,position ('-' in contactfullname)+2)

---cau4--- 
select extract(month from orderdate),
	extract (year from orderdate),
(	case 
	when extract (month from orderdate) in(1,2,3)then 1 
	when extract (month from orderdate) in(4,5,6) then 2
	when extract (month from orderdate) in(7,8,9) then 3
	else 4
	end )
	from sales_dataset_rfm_prj
---chạy trước lệnh 
	alter table sales_dataset_rfm_prj
	add column QTR_ID numeric,
	add column MONTH_ID numeric,
	add column YEAR_ID int 
---thêm cột 
update sales_dataset_rfm_prj
	set QTR_ID= (case 
	when extract (month from orderdate) in(1,2,3)then 1 
	when extract (month from orderdate) in(4,5,6) then 2
	when extract (month from orderdate) in(7,8,9) then 3
	else 4
	end )

update sales_dataset_rfm_prj
	set MONTH_ID = extract(month from orderdate)

update sales_dataset_rfm_prj 
	set YEAR_ID = extract (year from orderdate)
---update 

---cau5---
---boxplot 
with cte as (	
	select 
	Q1-1.5*IQR AS min_value, 
	Q3+1.5*IQR AS max_value
	from(
	select 
	percentile_cont(0.25) within group (order by quantityordered) as Q1,
	percentile_cont(0.75) within group (order by quantityordered) as Q3,
	(percentile_cont(0.75) within group (order by quantityordered)  -
	percentile_cont(0.25) within group (order by quantityordered) ) as IQR
	from sales_dataset_rfm_prj) as a )

select * 
	from sales_dataset_rfm_prj
	where quantityordered between (select  min_value from cte)
	and (select max_value from cte)
---z-score 
with cte as (	
select *,
(select avg(quantityordered) from sales_dataset_rfm_prj) as avg
,(select stddev(quantityordered) from sales_dataset_rfm_prj) as stddev
from sales_dataset_rfm_prj) 

	select c.*
	from sales_dataset_rfm_prj as c 
	join cte as a on a.ordernumber=c.ordernumber
	where not  abs((a.quantityordered-avg)/stddev) >3 
	

