

select * from track

SELECT 
	track_id
	, name
	, composer
	, album_id
FROM track;


select 9/3;

select 10/4.;

select 9/4::numeric;

select * 
from track

select 
	name
	, round(milliseconds / 60000., 2) as duration_in_min
from track


select round(6590, -2)

select * 
from track
order by
	name desc
	, milliseconds
limit 10

select *
from track
offset 10
limit 10

/*
 Порядок обработки команд со стороны СУБД
 1 from
 2 select
 3 offset
 4 limit
 */

select * 
from track 
where album_id = 3
;

select *
from track
where 
	composer = 'Queen'
	or track.composer = 'U2'
	or track.composer = 'AC/DC'
	
select *
from track
where
	track.composer  in ('Queen', 'AC/DC', 'U2', 'Linkin Park')
	
select *
from track 
where 
	composer = 'Queen'
	and bytes > 9000000
;


select *
from track 
where 
	track.composer = 'Queen'
	or track.composer = 'AC/DC'
order by 
	bytes

select *
from track 
where 
	bytes > 9000000
	and (composer = 'Queen'
	or composer = 'AC/DC')
;

select *
from track
where 
	composer is null

select *
from track
where 
	composer is not null
;

select count(distinct composer)
from track
;

select distinct album_id
, sum(album_id)
from track
group by composer
;


select distinct 
	country 
	, state 
from customer
;


select country 
	, count(customer_id) as customer_cnt
from customer
group by 
	country
;

/*
 * 1. from
 * 2. where
 * 3. group by
 * 4. select
 * 5. offset 
 */

select country 
	, count(customer_id) as customer_cnt
from customer
where 
	country != 'USA'
group by 
	country
having 
	count(customer_id) > 2
order by 
	customer_cnt 
;


select
	country
	, state
	, count(customer_id) as customer_cnt
from customer
group by
	country 
	, state
;













