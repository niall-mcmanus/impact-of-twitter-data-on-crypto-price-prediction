select 
cast(close_time as date)
,sum(num_tweets)
from

(
SELECT t1.coin
	   , t1.close_price
       ,close_timestamp as close_time
       , tim as tweet_time
       , num_tweets
       , avg_senti
       , min_senti
       , max_senti

FROM mcm_practicum.xlmbtc		as t1

INNER JOIN
			(
            SELECT FROM_UNIXTIME(CEIL(UNIX_TIMESTAMP(tweet_date)/1800)*1800) as tim  # rounding to the next thirty minutes for aggregations  
				 , count(id) as num_tweets
				 , avg(sentiment) as avg_senti
				 , MIN(sentiment) min_senti
				 , MAX(sentiment) max_senti

			FROM mcm_practicum.xlm_tweets 

			 GROUP BY tim)T2
on t2.tim = date_sub(t1.close_timestamp, interval 30 minute) # stagger data so sentiment occurred at least thirty minutes before price 
)bse

group by 1 order by 1;
