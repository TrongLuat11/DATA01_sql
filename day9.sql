---baitap1---
SELECT 
sum(case 
when device_type = 'laptop' then 1
end) as laptop_view,

sum(CASE 
when device_type in ('phone','tablet') then 1
end) as mobile_view
FROM viewership
---baitap2---
-- Write your PostgreSQL query statement below
select*,
case
when x+y>z and x+z>y and y+z>x then 'Yes'
else 'No'
end as triangle
from Triangle
---baitap3---
SELECT 
round(100.0* SUM(CASE
when call_category is null then 1
when call_category = 'n/a' then 1
end)/ count(*) ,1) as uncategorised_call_pct
from callers
---baitap4---
select 
name
from Customer
where  not referee_id = 2 or referee_id is null
---baitap5---
SELECT
    survived,
    sum(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    sum(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    sum(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY 
    survived


