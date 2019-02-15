create table mcm_practicum.xmrbtc
(
coin char (6),
close_price decimal (10,8),
close_timestamp timestamp,
high_price decimal (10,8),
low_price decimal (10,8),
open_price decimal (10,8)
);

delete from mcm_practicum.xmrbtc;

/* first xmr insert */
load data local infile 'xxxxxxxxx.csv' 
into table mcm_practicum.xmrbtc fields terminated by ','
  enclosed by '"'
  lines terminated by '\n';

/* second xmr insert */
load data local infile 'xxxxxxxxx.csv' 
into table mcm_practicum.xmrbtc fields terminated by ','
  enclosed by '"'
  lines terminated by '\n';

/**********************************************************************************************************************************************************/

/*testing */
select * from mcm_practicum.xmrbtc
/* check duplicates  */
select count(close_price ||close_timestamp) , count(*) from  mcm_practicum.xmrbtc ;

/* delete erroneous records (clock change is messing up mysql upload) */
delete FROM mcm_practicum.xmrbtc  where close_timestamp = '2018-03-25 02:00:00'