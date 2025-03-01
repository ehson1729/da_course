select 
	invoice_id,
	customer_id,
	case billing_country
		when 'Germany' then 'DEU'
		when 'France' then 'FRA'
		when 'Spain' then 'ESP'
		else billing_country
	end as country_code
from invoice;

SELECT 
	invoice_id,
	customer_id, 
	CASE 
		WHEN billing_country IN ('USA', 'Canada', 'Mexico') 
		THEN 'North America'
		WHEN billing_country IN ('Brasil', 'Argentina', 'Chile') 
		THEN 'North America'
		WHEN billing_country IN ('India', 'China', 'Australia') 
		THEN 'North America'
		else 'Europe'
	end as continent
	from invoice
	
select
	track_id,
	name,
	milliseconds,
	case 
		when milliseconds / 60000. > 60 then 'over_1h'
		when milliseconds / 60000. > 30 then 'over_30m'
		when milliseconds / 60000. > 10 then 'over_10m'
		else 'below_10m'
	end duration_bucket
from track
	
create view v_track as
select 
	track_id
	, name as track_name
	, composer
	, genre_id
	, album_id
	, round(milliseconds/60000., 2) as duration
	, round(bytes / 1024. / 1024., 2) as size_mb
from track;

select 
	case
		when duration > 60 then 'over_1h'
		when duration > 30 then 'over_30m'
		when duration > 10 then 'over_10m'
		else 'less_than_10m'
	end as duration_bucket
	, round(avg(duration),2) as avg_duration
from v_track
group by duration_bucket; --ньюнс в postgresql

/*
 from
 join
 where
 group by
 having
 window
 select
 	case
 offset
 limit
 order by
 */
