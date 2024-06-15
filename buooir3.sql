---baitap1---
select NAME FROM CITY 
WHERE COUNTRYCODE = 'USA' AND POPULATION >120000
---baitap2---
SELECT * FROM CITY 
WHERE COUNTRYCODE = 'JPN'
---baitap3---
SELECT CITY, STATE FROM STATION
---baitap4---
SELECT CITY FROM STATION 
WHERE CITY LIKE 'a%' or 
              CITY LIKE 'e%' or
              CITY LIKE 'i%' or
              CITY LIKE 'o%' or
              CITY LIKE 'u%'
---baitap5---
SELECT distinct CITY FROM STATION 
WHERE CITY LIKE '%a' or 
              CITY LIKE '%e' or
              CITY LIKE '%i' or
              CITY LIKE '%o' or
              CITY LIKE '%u'
---baitap6---
SELECT DISTINCT CITY FROM STATION 
WHERE NOT ( CITY LIKE 'a%' or 
              CITY LIKE 'e%' or
              CITY LIKE 'i%' or
              CITY LIKE 'o%' or
              CITY LIKE 'u%')
---baitap7---
select name from Employee
order by name 
---baitap8---
SELECT name from Employee
where salary >2000 and months <10
---baitap9---
select product_id from Products 
where low_fats = 'Y' and recyclable ='Y';
---baitap10---
select name from Customer 
where referee_id <>2 or referee_id is null
---baitap11---
select name, population,area  from World
where population >=25000000 or area >=3000000
---baitap12---
select distinct viewer_id AS id 
from Views 
where viewer_id = author_id
order by id 
---baitap13---
SELECT part, assembly_step FROM parts_assembly
where finish_date is null;
---baitap14---
select * from lyft_drivers
where yearly_salary <=30000 or yearly_salary >=70000
---baitap15---
select * from uber_advertising
where money_spent > 100000





