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

, cte_main as( 
	select *,
  quantityordered * sales as revenue
	from sales_dataset_rfm_prj
	where quantityordered between (select  min_value from cte)
	and (select max_value from cte))

---/*1) Doanh thu theo từng ProductLine, Year  và DealSize?*/
select productline, year_id, dealsize, 
	sum(revenue) 
from cte_main
group by productline, year_id, dealsize

---/*2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
*/
select month_id, revenue, ordernumber
	from cte_main 
	where revenue in (select max(revenue) 
from cte_main
group by year_id)
---/*3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
*/
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

, cte_main as( 
	select *,
	quantityordered * sales as revenue 
	from sales_dataset_rfm_prj
	where quantityordered between (select  min_value from cte)
	and (select max_value from cte))

,kkk as(	select month_id, sum(revenue) as revenue, 
	sum(quantityordered) as quantityordered,
	ordernumber 
	from cte_main
	where month_id=11
group by ordernumber, year_id, month_id ) 

	select  month_id,revenue,ordernumber 
	from kkk
where quantityordered in (select max(quantityordered) from kkk)
---/*4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK
*/
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

, cte_main as( 
	select *,
	quantityordered * sales as revenue 
	from sales_dataset_rfm_prj
	where quantityordered between (select  min_value from cte)
	and (select max_value from cte))

select * 
	from(
	select  year_id, productline, sum(revenue) as total_revenue, 
	row_number() over (partition by year_id order by year_id) as rank 
	from cte_main
	where country ='UK'
	group by year_id, productline) as a 
where rank = 1 
---/*5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23)
*/
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

, cte_main as( 
	select *,
	quantityordered * sales as revenue 
	from sales_dataset_rfm_prj
	where quantityordered between (select  min_value from cte)
	and (select max_value from cte))


,contactfullname as(	select contactfullname, 
	current_date- Max(cast(orderdate as timestamp) ) as R,  
	count(distinct ordernumber)as F,
	sum(sales) as M 
	from cte_main
	group by contactfullname)

, rfm_score as (select
	contactfullname,
	ntile(5) over (order by R desc) R_score,
	ntile(5) over (order by F ) F_score,
	ntile(5) over (order by M ) M_score	
from contactfullname)

, rfm_final as(	select contactfullname, 
	cast(R_score as varchar)||cast(F_score as varchar)||cast(M_score as varchar) 
	as rfm_score  
from rfm_score)
	
select segment, contactfullname,
		count(*) from (
select a.contactfullname, 
b.segment
from rfm_final a 
join segment_score b 
on a.rfm_score =b. scores ) as a 
	where segment='Champions'
group by segment, contactfullname
order by count(*)


