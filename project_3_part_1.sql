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

/*1) Doanh thu theo từng ProductLine, Year  và DealSize?*/
select productline, year_id, dealsize, 
	sum(revenue) 
from cte_main
group by productline, year_id, dealsize

/*2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
*/
select month_id, revenue, ordernumber
	from cte_main 
	where revenue in (select max(revenue) 
from cte_main
group by year_id)
/*3) Product line nào được bán nhiều ở tháng 11?
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
/*4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
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
/*5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
(sử dụng lại bảng customer_segment ở buổi học 23)
*/

