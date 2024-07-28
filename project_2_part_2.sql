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
