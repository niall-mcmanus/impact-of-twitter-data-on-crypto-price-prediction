/* testing for duplicates */

SELECT * FROM mcm_practicum.xlm_tweets;
SELECT * FROM mcm_practicum.xlm;

select count(concat(id,tweet_date)) , count(distinct concat(id,tweet_date))FROM mcm_practicum.xlm_tweets;


select concat(id,tweet_date)as dte , count(concat(id,tweet_date)) as cnt 
FROM mcm_practicum.xlm_tweets 
group by 1
having cnt > 1
;

select concat(id,tweet_date)as dte , count(concat(id,tweet_date)) as cnt 
FROM mcm_practicum.xmr_tweets 
group by 1
having cnt > 1
;

select concat(id,tweet_date)as dte , count(concat(id,tweet_date)) as cnt 
FROM mcm_practicum.xrp_tweets 
group by 1
having cnt > 1
;

select count(concat(id,tweet_date)) , count(distinct concat(id,tweet_date))FROM mcm_practicum.xrp_tweets;

/**********************************************************************************************************************************************************/

/* remove duplicates in tweets table */
create table mcm_practicum.xlm_tweets2
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xlm_tweets 
)
;
drop table mcm_practicum.xlm_tweets;
create table mcm_practicum.xlm_tweets
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xlm_tweets2 
)
;
select * from  mcm_practicum.xlm_tweets;
drop table mcm_practicum.xlm_tweets2;

/***********************************************************************/

create table mcm_practicum.xrp_tweets2
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xrp_tweets 
)
;
drop table mcm_practicum.xrp_tweets;
create table mcm_practicum.xrp_tweets
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xrp_tweets2 
)
;
select * from  mcm_practicum.xrp_tweets;
drop table mcm_practicum.xrp_tweets2;


select count(concat(id,tweet_date)) , count(distinct concat(id,tweet_date))FROM mcm_practicum.xlm_tweets;
select count(concat(id,tweet_date)) , count(distinct concat(id,tweet_date))FROM mcm_practicum.xmr_tweets;
select count(concat(id,tweet_date)) , count(distinct concat(id,tweet_date))FROM mcm_practicum.xrp_tweets;


/**********************************************************************************************************************************************************/




/*prepping for merge with XLM & XMR price data */

/* check all price data present and same number of records in each table */
select count(concat(close_price,close_timestamp)) , count(distinct concat(close_price,close_timestamp))FROM mcm_practicum.xlm;
select count(concat(close_price,close_timestamp)) , count(distinct concat(close_price,close_timestamp))FROM mcm_practicum.xmr;
select count(concat(close_price,close_timestamp)) , count(distinct concat(close_price,close_timestamp))FROM mcm_practicum.bch;
select count(concat(close_price,close_timestamp)) , count(distinct concat(close_price,close_timestamp))FROM mcm_practicum.eth;
select count(concat(close_price,close_timestamp)) , count(distinct concat(close_price,close_timestamp))FROM mcm_practicum.ltc;
select count(concat(close_price,close_timestamp)) , count(distinct concat(close_price,close_timestamp))FROM mcm_practicum.xrp;

/* used to check disparities */
/*select * from 
(
select xmr.close_timestamp as xmr_time , xmr.close_price as xmr_close
, xlm.close_timestamp as xlm_time , xlm.close_price as xlm_close

from mcm_practicum.xmr	as xmr

left join mcm_practicum.xlm as xlm
on xlm.close_timestamp = xmr.close_timestamp

)t1

where xlm_close is null*/
select * from mcm_practicum.xmr_btc

/*====================================================================================================================*/

/* testing for python */

/* xmr*/ 
SELECT t1.coin
	   , t1.close_price
       ,close_timestamp as close_time
       , tim as tweet_time
       , num_tweets
       , avg_senti
       , min_senti
       , max_senti

FROM mcm_practicum.xmrbtc		as t1

INNER JOIN
			(
            SELECT FROM_UNIXTIME(CEIL(UNIX_TIMESTAMP(tweet_date)/1800)*1800) as tim  # rounding to the next thirty minutes for aggregations  
				 , count(id) as num_tweets
				 , avg(sentiment) as avg_senti
				 , MIN(sentiment) min_senti
				 , MAX(sentiment) max_senti

			FROM mcm_practicum.xmr_tweets 

			 GROUP BY tim)T2
on t2.tim = date_sub(t1.close_timestamp, interval 30 minute) # stagger data so sentiment occurred at least thirty minutes before price 
;

/* more testing */

SELECT close_timestamp as close_time
       

FROM mcm_practicum.xmr		as t1

INNER JOIN
			(
select tim, num_tweet , case when favs = 0 then 0 else favs/num_tweet end as fav_percent
, case when retweet = 0 then 0 else retweet/num_tweet end as retweet_percent
, retweet
,avg_senti
,max_senti
,min_senti
from
(
select FROM_UNIXTIME(CEIL(UNIX_TIMESTAMP(tweet_date)/1800)*1800) as tim  # rounding to the next thirty minutes for aggregations 
				 , count(id) as num_tweet	
                 , sum(favorites) as favs
                 , sum(retweets)  as retweet
				 , avg(sentiment) as avg_senti
				 , MIN(sentiment) as min_senti
				 , MAX(sentiment) as max_senti
 FROM mcm_practicum.xlm_tweets 
 
 group by tim
 )st1
 )t2
on t2.tim = date_sub(t1.close_timestamp, interval 30 minute) # stagger data so sentiment occurred at least thirty minutes before price 


where close_timestamp not in (
SELECT close_timestamp
       

FROM mcm_practicum.xlm		as t1

INNER JOIN
			(
            SELECT FROM_UNIXTIME(CEIL(UNIX_TIMESTAMP(tweet_date)/1800)*1800) as tim  # rounding to the next thirty minutes for aggregations 
				 , count(id) as num_tweet			
				 , avg(sentiment) as avg_senti
				 , MIN(sentiment) min_senti
				 , MAX(sentiment) max_senti

			FROM mcm_practicum.xlm_tweets 

			 GROUP BY tim)T2
on t2.tim = date_sub(t1.close_timestamp, interval 30 minute) # stagger data so sentiment occurred at least thirty minutes before price 
);

/* testing aggregations */
select sum(favs)
from
(
select FROM_UNIXTIME(CEIL(UNIX_TIMESTAMP(tweet_date)/1800)*1800) as tim  # rounding to the next thirty minutes for aggregations 
				 , count(id) as num_tweet	
                 , sum(favorites) as favs
                 , sum(retweets)  as retweet
				 , avg(sentiment) as avg_senti
				 , MIN(sentiment) as min_senti
				 , MAX(sentiment) as max_senti
 FROM mcm_practicum.xlm_tweets 
 
 group by tim
 )t1;
 select sum(favorites)  FROM mcm_practicum.xlm_tweets ;
 
 
 
 /* testing aggregations */
 
 select FROM_UNIXTIME(CEIL(UNIX_TIMESTAMP(tweet_date)/1800)*1800) as tim  # rounding to the next thirty minutes for aggregations 
				 , count(id) as num_tweet	
                 , sum(favorites) as favs
                 , sum(retweets)  as retweet
				 , avg(sentiment) as avg_senti
				 , MIN(sentiment) as min_senti
				 , MAX(sentiment) as max_senti
 FROM mcm_practicum.xlm_tweets 
 
 group by tim
 having tim = '2018-03-20 23:00:00' ;
 
 
  select * 
 FROM mcm_practicum.xlm_tweets 
 where tweet_date between '2018-03-20 22:30:01' and '2018-03-20 23:00:00'
 
select month(tweet_date) , count(*) 
 FROM mcm_practicum.xlm_tweets 
 group by 1;
 
 select min(tweet_date) , max(tweet_date) FROM mcm_practicum.xlm_tweets  
 
select  count(*) 
FROM mcm_practicum.xlm_tweets where tweet_date between '2018-02-19 00:00:00' and '2018-03-19 00:00:00' 
 
 
