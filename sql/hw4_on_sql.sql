	---Домашка #4 по SQL
	
/* В локальном репозитории da_course создайте ветку hw29. Переключитесь на новую ветку. 

 В DBeaver выберите команду Open SQL console и сохраните файл в репозитории под именем hw4_on_sql.sql.

⚠️ Решения с использованием явных и/или неявных джойнов засчитываться не будут.

1. По каждому сотруднику компании предоставьте следующую информацию: 
id сотрудника, полное имя, позиция (title), id менеджера (reports_to), полное имя менеджера и через запятую его позиция.

*/
	

;

select 
	employee_id
	, concat_ws(' ', first_name, last_name) as employee_name
	, title as  employee_position
	, reports_to as manager_id
	, (select first_name || ' ' || last_name || ', ' || title
	from employee e2
	where
		e2.employee_id = e1.reports_to ) as manager_name_and_title
from employee e1
;

--2.Вытащите список чеков, сумма которых была больше среднего чека за 2023 год. Итоговая таблица должна содержать 
--следующие поля: invoice_id, invoice_date, monthkey (цифровой код состоящий из года и месяца), customer_id, total


select
	invoice_id
	, invoice_date
	, extract('year' from invoice_date) || '' || extract('month' from invoice_date) as monthkey
	, customer_id
	, total
from invoice
where 
	total >	(select
	 avg(total)
	from invoice 
	where 
		extract('year' from invoice_date) = 2023 )
;


--3. Дополните предыдущую информацию email-ом клиента.


select
	invoice_id
	, invoice_date
	, extract('year' from invoice_date) || '' || extract('month' from invoice_date) as monthkey
	, customer_id
	, total
	, (select email
		from customer
		where 
			invoice.customer_id = customer.customer_id)
from invoice
where 
	total >	(select
	 avg(total)
	from invoice 
	where 
		extract('year' from invoice_date) = 2023 )
;


--4. Отфильтруйте результирующий запрос, чтобы в нём не было клиентов имеющих почтовый ящик в домене gmail.

select
	invoice_id
	, invoice_date
	, extract('year' from invoice_date) || '' || extract('month' from invoice_date) as monthkey --TO_CHAR(invoice.invoice_date, 'YYYYMM') 
	, customer_id
	, total
	, (select email
		from customer
		where 
			invoice.customer_id = customer.customer_id)
from invoice
where 
	total >	(select
	 avg(total)
	from invoice 
	where 
		extract('year' from invoice_date) = 2023 )
and (select customer.email from customer where customer.customer_id = invoice.customer_id) not ilike '%@gmail.com';	

--5. Посчитайте какой процент от общей выручки за 2024 год принёс каждый чек.

select 
	i.invoice_id
	, customer_id
	, total
	, round(total / (
	select sum(total)
	from invoice i2
	where 
		extract('year' from invoice_date) = 2024), 4)
from invoice i 
where 
	extract('year' from invoice_date) = 2024
;

--6. Посчитайте какой процент от общей выручки за 2024 год принёс каждый клиент компании.

select 
	i.customer_id
	, round( sum(total) / (
	select sum(total)
	from invoice i2
	where 
		extract('year' from invoice_date) = 2024), 4)  as total_prc_2024 
from invoice i 
where 
	extract('year' from invoice_date) = 2024
group by 
	i.customer_id 
order by i.customer_id
;
		
		