--Операторы сочетания

create table tr1 as(
select
	track_id,
	name 
from track 
limit 5
);

create table tr2 as(
select
	track_id,
	name 
from track 
limit 5
offset 2
);

select * 
from tr1
union
select *
from tr2 
order by 
	track_id;


update tr2
set name = 'APT'
where  	
	track_id = 4
;

select * 
from tr1
union
select *
from tr2 
order by 
	track_id;
;

select * 
from tr1
intersect
select *
from tr2 
order by 
	track_id;
;

select * 
from tr1
except
select *
from tr2 
order by 
	track_id;
;


--Джойны 

select * 
from tr1
	left join tr2 
		on tr1.track_id = tr2.track_id

/*
 from
 join
 where
 group by
 order by
 having
 select
 offset
 limit 
 */

select * 
from tr1
	left join tr2 
		on tr1.track_id = tr2.track_id
;

select * 
from tr1
	right join tr2 
		on tr1.track_id = tr2.track_id
;

select * 
from tr2
	left join tr1 
		on tr1.track_id = tr2.track_id
;

select * 
from tr1
	inner join tr2 
		on tr1.track_id = tr2.track_id
;

select * 
from tr1
	full join tr2 
		on tr1.track_id = tr2.track_id
;


select
	t.track_id
	, t.name as track_name
	, g.name as genre_name
from track t
	left join genre g 
		on t.genre_id = g.genre_id
;


select * 
from track t
	inner join genre g
		on t.genre_id = g.genre_id;
;


select 
	i.customer_id 
	, c.first_name || ' ' || c.last_name as full_name
	--concat_ws(' ',c.first_name, c.last_name ) as full_name
	, i.total
from invoice i
	left join customer c 
		on i.customer_id = c.customer_id
;

select *
from invoice i 
;

select *
from customer c
;


update tr2
set track_id = 3
where
	name = 'APT'
;

select * 
from tr2


select * 
from tr1 
	left join tr2
		on tr1.track_id = tr2.track_id
		
update tr2
set track_id = 5
where
	track_id = 7
;

select *
from employee
;


--SELFJOIN
select 
	e1.employee_id
	, e1.last_name
	, count(e2.employee_id) as sub_cnt
from employee e1
	left join employee e2
		on e1.employee_id = e2.reports_to
group by
	e1.employee_id
	, e1.last_name
order by
	e1.employee_id
;


--anti join

select
	t.track_id
	, t.name
	, t.unit_price
	, il.track_id
from track t 
	left join invoice_line il 
		on t.track_id = il.track_id
where
	il.track_id is null
order by
	t.unit_price desc
;

--semi join 
select
	t.track_id
	, t."name"
from track t
where 
	t.track_id in (
		select t.track_id
		from invoice_line il 
	)
;

select
	t.track_id
	, t."name"
from track t
where 
	exists (
		select 1
		from invoice_line il
		where 
			il.track_id  = t.track_id
	)
;


select make_interval(days => 1)
