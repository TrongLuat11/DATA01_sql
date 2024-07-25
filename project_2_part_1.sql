---caau1---
with bt1 as(
select 
a.id as id ,
b.order_id as order_id,
format_date('%y-%m',b.created_at) as created_at
from bigquery-public-data.thelook_ecommerce.users as a 
join bigquery-public-data.thelook_ecommerce.orders as b
on a.id = b.user_id)

select 
created_at,
count(id) as sum_customer,
count(order_id) as sum_order
from bt1 
where created_at between '19-01' and '22-05'
group by bt1.created_at
order by created_at

---cau2----------
with bt2 as (
select 
format_date('%y-%m',b.created_at) as created_at, 
a.user_id,
b.order_id,
b.sale_price 
from bigquery-public-data.thelook_ecommerce.orders as a  
join bigquery-public-data.thelook_ecommerce.order_items as b  
on a.order_id= b.order_id)

select 
created_at,
count(user_id) as sum_customer,
sum(sale_price)/count(order_id) as avg_order
from bt2
where created_at between'19-01' and '22-04'
group by created_at 


---baitap3----
with bt3 as (
select 
format_date('%y-%m',b.created_at) as created_at, 
a.user_id,
from bigquery-public-data.thelook_ecommerce.orders as a  
join bigquery-public-data.thelook_ecommerce.order_items as b  
on a.order_id= b.order_id)


select b.created_at,
first_name, last_name, gender, age,
(case 
when age =(select max(age) from bigquery-public-data.thelook_ecommerce.users) then 'tuoi_gia_nhat'
when age =(select min(age) from bigquery-public-data.thelook_ecommerce.users) then 'tuoi_tre_nhat'
else ''
end) as tag
from bigquery-public-data.thelook_ecommerce.users as a 
join bt3 as b 
on a.id=b.user_id
where b.created_at between '19-01' and '22-04'

----cau4----
with bt4 as (
select
format_date('%y-%m',b.created_at) as month_year,
b.product_id,
a.name as product_name,
a.retail_price as sales,
a.cost,
(a.retail_price-a.cost) as profit, 
from bigquery-public-data.thelook_ecommerce.products as a
join bigquery-public-data.thelook_ecommerce.order_items as b 
on a.id=b.product_id
order by profit desc)

,bt4_main as( 
select *,
dense_rank() over (partition by month_year ORDER BY profit desc ) as rank 
from bt4 )

select * from bt4_main 
where rank <=5 
order by month_year 

--ccau5---


