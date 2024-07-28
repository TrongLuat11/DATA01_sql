----câu 1 -----
with cte1 as 
(select 
format_date('%y-%m',created_at) as Month,
format_date('%y',created_at) as Year,
b.retail_price as revenue,
a.order_id,
b.cost,
b.category as product_category  
from bigquery-public-data.thelook_ecommerce.order_items as a 
join bigquery-public-data.thelook_ecommerce.products as b 
on a.product_id=b.id
order by Month )

,cte2 as(
select Product_category,
Month,
Year,
sum(revenue) as TPV, 
lead(sum(revenue),1) over (partition by Product_category order by Month ) as TPV_next_month,
sum(cost) as total_cost, 
count(order_id) as TPO,
lead(count(order_id),1) over(partition by Product_category order by Month) as TPO_next_month,
sum(revenue) - sum(cost) as profit 
from cte1 
group by  product_category,Month, Year
order by product_category,Month)

select
Month, Year, Product_category,
TPV,TPO,
round((TPV_next_month-TPV)/TPV,2) ||'%' as Revenue_growth,
round((TPO_next_month-TPO)/TPO,2) ||'%' as Order_growth,
total_cost,
profit as total_profit,
round((profit/total_cost),3) as Profit_to_cost_ratio
from cte2 


--- câu 2 ----
with cte1_convert as(
select 
user_id,
cast(created_at as timestamp) as created_at,
cast(returned_at as timestamp) as returned_at,
cast(shipped_at as timestamp) as shipped_at,
cast(delivered_at as timestamp) as delivered_at 
from bigquery-public-data.thelook_ecommerce.order_items  
where not created_at is null and user_id is not null
and shipped_at > created_at)

,cte1_main as (
  select * from (select user_id ,created_at,
row_number()over (partition by created_at, user_id order by created_at) as stt 
from cte1_convert ) as t 
where stt =1)

, cte1_main_index as (
select user_id,
format_date('%y-%m',first_created_order) as cohort ,
(extract(year from created_at)-extract(year from  first_created_order ))*12
+(extract(month from created_at)-extract(month from  first_created_order ))+1
as index
from ( 
  select 
  user_id, 
  min(created_at) over (partition by user_id ) as first_created_order,
  created_at
  from cte1_main) as a )
,xxx as(
  select 
  cohort,
  mod(index,12) as index,
  count(distinct user_id) cnt 
  from cte1_main_index
  group by cohort,index ) 
  
  ,cohort1 as (
  select
  cohort,
  sum(case when index=1 then cnt else 0 end) as m0,
  sum(case when index=2 then cnt else 0 end) as m1,
  sum(case when index=3 then cnt else 0 end) as m2,
  sum(case when index=4 then cnt else 0 end) as m3
  from xxx
group by cohort 
order by cohort )

select 
cohort,
round(100.00*m0/m0,2)||'%' as n0,
round(100.00*m1/m0,2)||'%' as n1,
round(100.00*m2/m0,2)||'%' as n2,
round(100.00*m3/m0,2)||'%' as n3
from cohort1 

