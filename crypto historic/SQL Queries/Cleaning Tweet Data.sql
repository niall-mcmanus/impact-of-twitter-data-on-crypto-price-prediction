/***********************************************************************************************************/

/* remove duplicates in tweets table */
create table mcm_practicum.xlm_tweets3
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xlm_tweets2 
)
;
drop table mcm_practicum.xlm_tweets2;
create table mcm_practicum.xlm_tweets2
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xlm_tweets3 
)
;
select * from  mcm_practicum.xlm_tweets2;
drop table mcm_practicum.xlm_tweets3;


/***********************************************************************************************************/


/* remove duplicates in tweets table */
create table mcm_practicum.xmr_tweets3
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xmr_tweets2 
)
;
drop table mcm_practicum.xmr_tweets2;
create table mcm_practicum.xmr_tweets2
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xmr_tweets3 
)
;
select * from  mcm_practicum.xmr_tweets2;
drop table mcm_practicum.xmr_tweets3;

/***********************************************************************************************************/

/* remove duplicates in tweets table */
create table mcm_practicum.xrp_tweets3
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xrp_tweets2 
)
;
drop table mcm_practicum.xrp_tweets2;
create table mcm_practicum.xrp_tweets2
as
(
select distinct id, tweet_date, retweets, favorites, sentiment 
from mcm_practicum.xrp_tweets3 
)
;
select * from  mcm_practicum.xrp_tweets2;
drop table mcm_practicum.xrp_tweets3;

/***********************************************************************/
select min(tweet_date) , max(tweet_date)  from mcm_practicum.xlm_tweets2;
select min(tweet_date) , max(tweet_date)  from mcm_practicum.xmr_tweets2;
select min(tweet_date) , max(tweet_date)  from mcm_practicum.xrp_tweets2;

