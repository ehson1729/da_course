create schema if not exists store;


set search_path to store;

select current_schema;


create table if not exists customers(
	customer_id serial
	, customer_name varchar(50) not null
	, email varchar(260) 
	, address text
	, primary key (customer_id)
);

select *
from customers
;

/*
Заполните таблицу данными из таблицы customer датасета chinook.
При этом, значения для поля customer_name должны быть составлены 
из полей first_name и last_name исходной таблицы. 
А значения для поля address должно быть составлено из полей
country, state, city и address исходной таблицы. В качестве делимитера между значениями должен использовать пробел.
*/
select * 
from public.customer

insert into customers(customer_name, email, address)
select 
	first_name || ' ' || last_name as customer_name
	, email
	, concat_ws(' ', country, state, city, address) as address
from public.customer
;


/*
Создайте таблицу products со следующими полями:
product_id - id продукта; основной ключ таблицы
product_name - название продукта; не может содержать больше 100 символов; но может быть пустым
price -цена продукта; не может быть пустым
*/

create table if not exists products(
	product_id serial
	, product_name varchar(100)
	, price integer not null
	, primary key (product_id)
);

/*
  Заполните таблицу списком следующих товаров:
Ноутбук Lenovo Thinkpad; 12000
Мышь для компьютера, беспроводная; 90
Подставка для ноутбука; 300
Шнур электрический для ПК; 160
 */

insert into products(product_name, price)
values
	('Ноутбук Lenovo Thinkpad', 12000)
	, ('Мышь для компьютера, беспроводная', 90)
	, ('Подставка для ноутбука', 300)
	, ('Шнур электрический для ПК', 160)
;

select *
from products

/*
 6. Создайте таблицу sales, со следующими полями:
sale_id - id продажи; основной ключ таблицы
sale_timestamp - время продажи; не может быть пустым; по умолчанию равно текущей дате и времени
customer_id - id клиента; не может быть пустым; является внешним ключём, ссылающимся на поле customer_id таблицы customers
product_id - id продукта; не может быть пустым; является внешним ключём, ссылающимся на поле product_id таблицы products
quantity - количество проданного товара; не может быть пустым; по умолчанию равно единице
*/

create table if not exists sales(
	sale_id serial primary key
	, sale_timestamp timestamp not null default localtimestamp
	, customer_id INT NOT NULL
    , product_id INT NOT NULL
	, quantity integer not null default 1
	, foreign key (customer_id) references customers(customer_id) on delete cascade
	, foreign key (product_id) references products(product_id) on delete cascade
);

select * 
from sales

insert into sales(customer_id, product_id, quantity)
values
	(3, 4, 1)
	, (56, 2, 3)
	, (11, 2, 1)
	, (31, 2, 1)
	, (24, 2, 3)
	, (27, 2, 1)
	, (37, 3, 2)
	, (35, 1, 2)
	, (21, 1, 2)
	, (31, 2, 2)
	, (15, 1, 1)
	, (29, 2, 1)
	, (12, 2, 1)
;

--8.Добавьте столбец discount в таблицу sales и установите его значение равным 0.2 для всех строк где product_id равен 1

alter table sales
add column discount numeric(5,2) default 0

update sales 
set discount = 0.2
where
	product_id = 1
;


select * 
from sales

--9. Создайте представление v_usa_customers, которое возвращает список всех клиентов из США

create view v_usa_customers as
select * 
from customers
where regexp_like( address, '^USA ') 

select * 
from v_usa_customers


 drop view v_usa_customers
