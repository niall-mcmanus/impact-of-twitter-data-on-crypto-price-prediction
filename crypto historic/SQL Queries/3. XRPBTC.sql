/*drop table mcm_practicum.xrpbtc;*/
create table mcm_practicum.xrpbtc
(
coin char (6) not null,
close_price decimal (10,8),
close_timestamp timestamp,
high_price decimal (10,8),
low_price decimal (10,8),
open_price decimal (10,8)
);

delete from mcm_practicum.xrpbtc;

/* first xrp insert */
load data local infile 'xxxxxxxxx.csv' 
into table mcm_practicum.xrpbtc fields terminated by ','
  enclosed by '"'
  lines terminated by '\n';

/* second xrp insert */
load data local infile 'xxxxxxxxx.csv' 
into table mcm_practicum.xrpbtc fields terminated by ','
  enclosed by '"'
  lines terminated by '\n';
  
  
/**********************************************************************************************************************************************************/

/*testing */
/*check duplicates*/
select close_timestamp , count(close_timestamp) cnt

FROM mcm_practicum.xrpbtc
group by 1
having cnt > 1
;

select * from mcm_practicum.XRPBTC

select MIN(close_timestamp) , MAX(close_timestamp) from  mcm_practicum.xrpbtc ;
/* check duplicates  */
select count(close_price ||close_timestamp) , count(*) from  mcm_practicum.xrpbtc ;

/* delete erroneous records (clock change is messing up mysql upload) */
delete FROM mcm_practicum.xrpbtc  where close_timestamp = '2018-03-25 02:00:00'