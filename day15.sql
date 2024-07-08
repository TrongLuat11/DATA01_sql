---baitap1---
with curr_year_spend  as(
SELECT extract(year from transaction_date) as year,
product_id, spend as curr_year_spend
FROM user_transactions 
) 
select b.year, b.product_id, b.curr_year_spend,
lag(curr_year_spend) over (partition by product_id order by b.year ) as prev_year_spend,
round(( b.curr_year_spend-lag(curr_year_spend) over (partition by product_id order by b.year)) /
(lag(curr_year_spend) over (partition by product_id order by b.year))*100,2) as yoy_rate
from curr_year_spend as b
---baitap2---
SELECT DISTINCT
  card_name,
  FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year, issue_month)
  AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC
---baitap3---
with cte as (
SELECT user_id, spend,transaction_date,
row_number() over(PARTITION BY user_id order by transaction_date) as row
FROM transactions)
select user_id, spend,transaction_date
from cte
where row=3
---baitap4---
SELECT 
transaction_date,
user_id,
COUNT(product_id)
FROM user_transactions
WHERE 
(user_id,transaction_date) IN (SELECT user_id,MAX(transaction_date) FROM user_transactions GROUP BY user_id)
GROUP BY transaction_date,
user_id
ORDER BY transaction_date
---baitap5---
WITH tb1 AS (
  SELECT *,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY tweet_date) AS rno 
  FROM (
      SELECT user_id, tweet_date, count(1) as count_tweet
      FROM tweets
      GROUP BY 1, 2
  ) AS counttweet_tb
),
tb2 AS (
  SELECT user_id, tweet_date, count_tweet, rno,
        CASE WHEN rno <= 3 THEN (SUM(count_tweet) OVER(PARTITION BY user_id ORDER BY tweet_date))
          ELSE 1 END AS consecutive_tweets
FROM tb1
)

SELECT user_id, tweet_date,
      CASE WHEN rno <= 3 THEN ROUND(consecutive_tweets/rno, 2) 
          ELSE ROUND(consecutive_tweets, 2) END AS rolling_avg_3days
FROM tb2


select user_id,tweet_date,
ROUND(AVG(tweet_count)
        OVER(PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
        AS rolling_avg_3d
from tweets;
---baitap6---

with cte as 
(SELECT merchant_id, credit_card_id, amount, transaction_timestamp,
lag(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount order by transaction_timestamp) 
as prev_transaction
FROM transactions
where EXTRACT(MINUTE from transaction_timestamp) <= 10
)

select COUNT(merchant_id) as payment_count
from cte where 
EXTRACT(MINUTE FROM transaction_timestamp)-EXTRACT(MINUTE FROM prev_transaction)<= 10

---baitap7---
WITH cte AS (
    SELECT category, product, SUM(spend) AS total_spend, RANK() OVER(
           PARTITION BY category ORDER BY SUM(spend) DESC) AS ranking
    FROM product_spend
    WHERE EXTRACT(YEAR FROM DATE(transaction_date)) = 2022
    GROUP BY category, product
)
SELECT category, product, total_spend
FROM cte 
WHERE ranking <= 2
---baitap8---
WITH cte AS (
    SELECT artist_name, COUNT(rank) AS song_appearances,
    DENSE_RANK() OVER(ORDER BY COUNT(rank) DESC) as artist_rank
    FROM artists a JOIN songs s
    ON a.artist_id = s.artist_id JOIN global_song_rank r
    ON s.song_id = r.song_id
    WHERE rank <= 10
    GROUP BY a.artist_name
)
SELECT artist_name, artist_rank
FROM cte 
WHERE artist_rank <= 5
