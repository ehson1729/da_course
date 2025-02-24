
-- ПОДЗАПРОСЫ


select avg(milliseconds)
from track 


select 
	track_id
	, name
	, milliseconds
from track
where 	
	milliseconds > (
		select avg(milliseconds)
		from track
	)
order by 
	milliseconds
;

select * 
from track

select *
from genre

select *
from track
where
	genre_id in (
		select 
			genre_id
		from genre
		where 
			name ilike '%r%'
);

select *
from invoice

select invoice_id
	, CUSTOMER_ID
	, invoice_date
	, total
	, (select sum(total) from invoice) as total_sum 
	, round(total / (select sum(total) from invoice), 4) as pct_total_sum 
from invoice


select *
from track

select *
from (
	select 
		track_id
		, name as track_name
		, round(milliseconds / 60000., 2) as duration_in_min
	from track
)
where 
	duration_in_min > 5
order by 
	duration_in_min
;


select avg (cc)
from (
	select 
		genre_id
		, count(track_id) as cc
	from 
		track
	group by 
		genre_id
	);

select max(full_name)
from (
	select
		length(first_name || ' ' || last_name) as full_name
	from customer
)
;

select
	track_id
	, name as track_name
	, genre_id
	, milliseconds
	, (
		select 
			round( avg(milliseconds), 2)
		from track t2
		where
			t2.genre_id = t1.genre_id
	) as genre_average
from track t1;

with
base as (
	select
		track_id
		, name as track_name
		, genre_id
		, round(milliseconds / 60000., 2) as duration
	from track
)
, by_genres as (
	select
		genre_id
		, avg(duration) as genre_avg
	from base
	group by
		genre_id
)
select
	track_id
	, track_name
	, genre_id
	, duration
	, (
		select round(genre_avg, 2)
		from by_genres bg
		where
			bg.genre_id = b.genre_id
	)
from base b;


