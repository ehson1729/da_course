

/*
 Задача №1
 
1.Посчитайте количество клиентов, закреплённых за каждым сотрудником (подсказка: в таблице customer есть поле support_rep_id, 
которое хранит employee_id сотрудника, за которым закреплён клиент). Итоговая таблица должна содержать следующие поля: 
id сотрудника, полное имя, количество клиентов.

2. Добавьте к получившейся таблице поле, показывающее какой процент от общей клиентской базы обслуживает каждый сотрудник.
*/

select 
	c.support_rep_id as id_employee
	, e.first_name || ' ' || e.last_name as full_name
	, count(c.customer_id) as amount_of_customers
	, round( (count(c.customer_id) / 1.0 / (select count(customer_id) as cnt
		from customer) ), 4)
	from customer c
		inner join employee e 
			on c.support_rep_id = e.employee_id
group by 
	c.support_rep_id
	, e.first_name || ' ' || e.last_name
;	

/*
 	Задача №2
 		
Верните список альбомов, треки из которых вообще не продавались. 
(если имеется ввиду только те альбомы в которых ничего не покупали то надо еще сравнить еол-во не проданных треков в альбоме с общим кол-вом треков в альбоме)
Итоговая таблица должна содержать следующие поля: название альбома, имя исполнителя.

*/

select album.title as album_name, artist.name as artist_name, album.album_id, track.track_id, invoice_line.track_id
from album
	inner join artist 
		on album.artist_id = artist.artist_id
	left join track 
		on album.album_id = track.album_id
	left join invoice_line 
		on track.track_id = invoice_line.track_id
where 
	invoice_line.track_id is null;

--3. Задача №3. Выведите список сотрудников у которых нет подчинённых.


select e1.employee_id
	, e1.first_name || ' ' || e1.last_name as full_name
from employee e1
	left join employee e2
		on e1.employee_id = e2.reports_to
where 
	e2.reports_to is null
	
	
--4. Верните список треков, которые продавались как в США так и в Канаде. Итоговая таблица должна содержать следующие поля: id трека, название трека.
	

with 
usa as (
select 
	i.invoice_id, 
	il.track_id
from invoice i 
	inner join invoice_line il 
		on i.invoice_id = il.invoice_id
where i.billing_country = 'USA'
), 
canada as (
select 
	i.invoice_id
	, il.track_id
from invoice i 
	inner join invoice_line il 
		on i.invoice_id = il.invoice_id
where i.billing_country = 'Canada'
)
select 
	usa.track_id, 
	t.name 
from usa 
	inner join canada
		on usa.track_id = canada.track_id
	inner join track t
		on t.track_id = usa.track_id
;


--5. Верните список треков, которые продавались в Канаде, но не продавались в США. 
--Итоговая таблица должна содержать следующие поля: id трека, название трека.


with 
usa as (
select 
	i.invoice_id, 
	il.track_id
from invoice i 
	inner join invoice_line il 
		on i.invoice_id = il.invoice_id
where i.billing_country = 'USA'
), 
canada as (
select 
	i.invoice_id
	, il.track_id
from invoice i 
	inner join invoice_line il 
		on i.invoice_id = il.invoice_id
where i.billing_country = 'Canada'
)
select 
	canada.track_id, 
	t.name 
from canada 
	left join usa
		on canada.track_id = usa.track_id
	inner join track t
		on canada.track_id = t.track_id 
where 
	usa.track_id is null
;