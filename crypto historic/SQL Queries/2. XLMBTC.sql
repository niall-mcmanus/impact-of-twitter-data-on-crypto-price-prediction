create table mcm_practicum.xlmbtc
(
coin char (6),
close_price decimal (10,8),
close_timestamp timestamp,
high_price decimal (10,8),
low_price decimal (10,8),
open_price decimal (10,8)
);

delete from mcm_practicum.xlmbtc;

/* first xlm insert */
load data local infile 'xxxxxxxxx.csv' 
into table mcm_practicum.xlmbtc fields terminated by ','
  enclosed by '"'
  lines terminated by '\n';

/* second xlm insert */
load data local infile 'xxxxxxxxx.csv' 
into table mcm_practicum.xlmbtc fields terminated by ','
  enclosed by '"'
  lines terminated by '\n';

/* check duplicates  */
select count(close_price ||close_timestamp) from  mcm_practicum.xlmbtc ;

select * from mcm_practicum.xlmbtc LIMIT 4650,30; ## checking rows

select count(close_timestamp) , count(distinct close_timestamp) from mcm_practicum.xlmbtc;

/**********************************************************************************************************************************************************/

/*testing */

/*check duplicates*/
select close_timestamp , count(close_timestamp) cnt

FROM mcm_practicum.xlmbtc
group by 1
having cnt > 1
;

/* delete erroneous records (clock change is messing up mysql upload) */
delete FROM mcm_practicum.xlmbtc  where close_timestamp = '2018-03-25 02:00:00'
