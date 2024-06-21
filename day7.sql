---baitap1---
SELECT Name
from STUDENTS
WHERE marks >75
order by right(name,3), ID ---hàm right có thể đặt dưới orderby mà kh cần đặt trên select---
---baitap2---
select user_id,
  upper(left(name,1)),
  lower(right(name,length(name)-1)),  
  upper(left(name,1)) || lower(right(name,length(name)-1)) as Name
from Users 
---baitap3---
---Output: manufaturer, sale :calculate the total drug sales for each manufacturer
---input
---dk loc
---Round the answer to the nearest millio
---descending order of total sales
---In case of any duplicates, sort them alphabetically by the manufacturer name.
SELECT 
manufacturer,
'$' ||round(sum(total_sales)/1000000,0)||' '||'million' as sale
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer 
---baitap4---
---output: mth,product,avg_stars
/*the average star rating for each product
grouped by month*/
---input
---đk lọc 
---the month as a numerical value: month ở định dạng số 
---rounded to two decimal places: làm tròn  số thập phân
---ort the output first by month and then by product ID.

SELECT 
extract(month from submit_date) as mth,
product_id,
round(AVG(stars),2) as avg_stars
FROM reviews
GROUP BY extract(month from submit_date),product_id
order by mth, product_id
---baitap5---
---output: sender_id	message_count
/*dentify the top 2 ent the highest number of messages Teams in August 2022
 total number of messages they sent.input*/
---input: messagae
---đk lọc
---the top 2 
--- in August 2022
---in descending order based on the count of the messages.

 select sender_id,
 count(message_id) as message_count
 --- số lương tin nhắn---
 from messages
 where extract(month from sent_date) = 8
      and extract (year from sent_date) =2022
 ---liên quan đến trường gốc và phái sinh là WHERE--
 ---hàm tông hợp mới dùng having---
 group by sender_id
 order by message_count desc
 limit 2
---baitap6---
---output
---input
---đk lọc
---Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.
select tweet_id
from tweets
where length(content) >15
---baitap7---
---baitap8---
select 
count(id) as number_employee
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) =2022
---baitap9---
select 
count(id) as number_employee
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) =2022
---baitap10---
select 
substring(title, length(winery)+2,4)
from winemag_p2
where country = 'Macedonia'

