
/*
	Задача №1

1. Для каждого клиента посчитайте сумму продаж по годам и месяцам. Итоговая таблица должна содержать следующие поля: 
customer_id, full_name, monthkey (в числовом формате), total.

2. Дополните получившуюся таблицу, посчитав для каждого клиента какой процент от общих продаж за каждый месяц он принёс.
 Т.е. если например в феврале 2023-го общая сумма продаж всем клиентам составила 100, а сумма продаж клиенту Х составила 15, 
 тогда процент расчитывается как 15/100.
 
3. Дополните таблицу, посчитав для каждого клиента нарастающий итог за каждый год.

4. Дополните таблицу, добавив для каждого клиента скользящее среднее за 3 последних периода 
(2 предыдущих периода и текущий период).

5. Дополните таблицу, посчитав для каждого клиента разницу между суммой текущего периода и суммой предыдущего периода.

*/

--1.1

select
	i.customer_id 
	, c.first_name || ' ' || c.last_name as full_name
	, to_char(i.invoice_date, 'YYYYMM') as monthkey
	, sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYYMM')
		) as total_1
from invoice i
	inner join customer c
		on i.customer_id = c.customer_id
	;

--1.2
select
	i.customer_id 
	, c.first_name || ' ' || c.last_name as full_name
	, to_char(i.invoice_date, 'YYYYMM') as monthkey
	, sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYYMM')
		) as total_1
	, round(( (sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYYMM')))  / (sum(i.total) over(
		partition by to_char(i.invoice_date, 'YYYYMM'))
		)),4) as total_in_prct_per_month_2
from invoice i
	inner join customer c
		on i.customer_id = c.customer_id
;

--1.3

select
	i.customer_id 
	, c.first_name || ' ' || c.last_name as full_name
	, to_char(i.invoice_date, 'YYYYMM') as monthkey
	, sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYYMM')
		)  as total_1
	, round(( (sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYYMM')))  / (sum(i.total) over(
		partition by to_char(i.invoice_date, 'YYYYMM'))
		)),4) as total_in_prct_per_month_2
	, sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYY')
		order by  to_char(i.invoice_date, 'YYYYMM')
		rows between unbounded preceding and current row)  as running_total_3
from invoice i
	inner join customer c
		on i.customer_id = c.customer_id
;

--1.4
select
	i.customer_id 
	, c.first_name || ' ' || c.last_name as full_name
	, to_char(i.invoice_date, 'YYYYMM') as monthkey
	, sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYYMM')
		)  as total_1
	, round(( (sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYYMM')))  / (sum(i.total) over(
		partition by to_char(i.invoice_date, 'YYYYMM'))
		)),4) as total_in_prct_per_month
	, sum(i.total) over(
		partition by i.customer_id
		, to_char(i.invoice_date, 'YYYY')
		order by to_char(i.invoice_date, 'YYYYMM') 
		rows between unbounded preceding and current row)  as running_total_3
	, avg(total) over(
		partition by i.customer_id
		order by to_char(i.invoice_date, 'YYYYMM')
		--order by i.invoice_id 
		rows between 2 preceding and current row
		)  as sliding_avg_4
from invoice i
	inner join customer c
		on i.customer_id = c.customer_id
	;

--1.5

with sales_data as (
	select
		i.customer_id 
		, c.first_name || ' ' || c.last_name as full_name
		, to_char(i.invoice_date, 'YYYYMM') as monthkey
		, sum(i.total) over(
			partition by i.customer_id, to_char(i.invoice_date, 'YYYYMM')
		)  as total_1
		, round(
			sum(i.total) over(partition by i.customer_id, to_char(i.invoice_date, 'YYYYMM')) / 
			sum(i.total) over(partition by to_char(i.invoice_date, 'YYYYMM')),4
		) as total_in_prct_per_month_2
		, sum(i.total) over(partition by i.customer_id, to_char(i.invoice_date, 'YYYY')
			order by to_char(i.invoice_date, 'YYYYMM')  
			rows between unbounded preceding and current row
		)  as running_total_3
	from invoice i
	inner join customer c
	on i.customer_id = c.customer_id
)
select
	*
	, avg(total_1) over(
		partition by customer_id
		order by monthkey
		--order by i.invoice_id 
		rows between 2 preceding and current row
	) as sliding_avg_4
	, total_1 - lag(total_1) over(
		partition by customer_id
		order by monthkey
		) as totaldiff_prev_and_now
from sales_data;

/*
  Задача №2
Верните топ 3 продаваемых альбома за каждый год. Итоговая таблица должна содержать 
следующие поля: год, название альбома, имя исполнителя, количество проданных треков.
 */

with 
album_sales as (
select 
        to_char(i.invoice_date, 'YYYY') as year
        , al.title as album_title
        , ar.name as artist_name
        , count(il.track_id) as total_sold_tracks
        , rank() over (
        	partition by to_char(i.invoice_date, 'YYYY') 
        	order by count(il.track_id) desc
        	) as rnk
    from invoice i
    inner join invoice_line il on i.invoice_id = il.invoice_id
    inner join track t on il.track_id = t.track_id
    inner join album al on t.album_id = al.album_id
    inner join artist ar on al.artist_id = ar.artist_id
    group by year
    	, al.album_id
    	, al.title
    	, ar.name
)
select year
	, album_title
	, artist_name
	, total_sold_tracks
from album_sales
where rnk <= 3
order by year desc
	, rnk;

/*
 Задача №3
 
1. Посчитайте количество клиентов, закреплённых за каждым сотрудником. 
Итоговая таблица должна содержать следующие поля: id сотрудника, 
полное имя, количество клиентов
2. К предыдущему запросу добавьте поле, показывающее какой 
процент от общей клиентской базы обслуживает каждый сотрудник.
*/


select
	 e.employee_id
	, e.first_name ||' '|| e.last_name as full_name
	, count(c.customer_id) as amt_of_clients
	, round((count(c.customer_id) / sum(count(c.customer_id)) over()) * 100.0 , 2) as prc_client
from customer c
inner join employee e on e.employee_id = c.support_rep_id
group by e.employee_id
	, full_name
order by amt_of_clients desc;


--4.Для каждого клиента определите дату первой и последней покупки.
--Посчитайте разницу в годах между первой и последней покупкой.


select 
	c.customer_id 
	, c.first_name ||' '|| c.last_name as full_name
	, min(i.invoice_date)
	, max(i.invoice_date) 
	, extract(year from age(max(i.invoice_date),min(i.invoice_date))) as between_year
from customer c 
inner join invoice i on c.customer_id = i.customer_id
group by c.customer_id
	, full_name
order by between_year
;