---baitap1---
  SELECT COUNTRY.CONTINENT,
FLOOR(AVG(CITY.POPULATION))
FROM CITY
INNER JOIN COUNTRY 
ON CITY.COUNTRYCODE= COUNTRY.CODE
GROUP BY  COUNTRY.CONTINENT
---baitap2---
SELECT COUNT(t.signup_action),
ROUND(SUM(CASE WHEN t.signup_action = 'Confirmed' THEN 1 ELSE 0 END)*1.0 / COUNT(t.signup_action),2)
FROM emails e LEFT JOIN texts t  
ON e.email_id  = t.email_id
WHERE 
  e.email_id IS NOT NULL
---baitap3---
SELECT b.age_buck
ROUND((SUM(CASE WHEN activity_type  = 'send' THEN time_spent ELSE 0 END)* 100.0 /SUM(time_spent)),2) AS send_perc, 
ROUND((SUM(CASE WHEN activity_type  = 'open' THEN time_spent ELSE 0 END)* 100.0 /SUM(time_spent)),2) AS open_perc 
FROM activities as a
LEFT JOIN age_breakdown as b ON a.user_id = b.user_id
WHERE activity_type IN ('open', 'send')
GROUP BY b.age_bucket;
---baitap4---
select cc.customer_id
from customer_contracts cc LEFT JOIN products p on cc.product_id=p.product_id
GROUP BY cc.customer_id 
HAVING COUNT(distinct p.product_category)=
(select count(DISTINCT product_category) from products)
---baitap5---
  select e1.employee_id,e1.name,count(*) as reports_count,round(avg(e2.age)) as average_age
from Employees e1 join employees e2 on e2.reports_to=e1.employee_id
group by e1.employee_id,e1.name
order by e1.employee_id;
---baitap6---
SELECT 
    p.product_name, 
    SUM(o.unit) AS unit
FROM Products p
LEFT JOIN Orders o 
ON p.product_id = o.product_id
WHERE  o.order_date > '2020-01-31' AND o.order_date < '2020-03-01'
GROUP BY  p.product_name
HAVING SUM(o.unit) >= 100
---baittap7---
SELECT page_id 
FROM pages
WHERE page_id 
    NOT IN
    (SELECT DISTINCT(page_id) from page_likes);



