/*
Ehson Kholzoda

Домашка #1 по SQL
В локальном репозитории da_course создайте ветку hw26. Переключитесь на новую ветку. 
В DBeaver выберите команду Open SQL console и сохраните файл в репозитории под именем hw1_on_sql.sql.

	
	1. Создайте многострочный комментарий со следующей информацией:
		ваши имя и фамилия
		описание задачи
	2. Напишите код, который вернёт из таблицы track поля name и genre_id
	3. Напишите код, который вернёт из таблицы track поля name, composer, unit_price. Переименуйте поля на song, author и price соответственно. 
	Расположите поля так, чтобы сначало следовало название произведения, далее его цена и в конце список авторов.
	4. Напишите код, который вернёт из таблицы track название произведения и его длительность в минутах. 
	Результат должен быть отсортирован по длительности произведения по убыванию.	
	5. Напишите код, который вернёт из таблицы track поля name и genre_id, и только первые 15 строк.
	6. Напишите код, который вернёт из таблицы track все поля и все строки начиная с 50-й строки.
	7. Напишите код, который вернёт из таблицы track названия всех произведений, чей объём больше 100 мегабайт (подсказка: 1mb=1048576 bytes).
	8. Напишите код, который вернёт из таблицы track поля name и composer, где composer не равен "U2". Код должен вернуть записи с 10 по 20-й включительно.

Сделайте коммит, пуш и создайте pull request.
В классруме прикрепите скриншот вкладки files changed вашего pull request-а.

**/


-- 2

select name 
	, genre_id
from track
;

-- 3 

select name song
	, unit_price price
	, composer author
from track
;

-- 4

select name 
	, round(milliseconds / 60000., 2) as minutes
from track 
order by minutes desc
;

--5

select name 
	, genre_id
from track 
limit 15
;

-- 6

select * 
from track 
offset 49
;

-- 7

select name 
from track
where bytes / 1048576. > 100
;

-- 8

select name 
	, composer 
from track 
where composer != 'U2'
offset 9
limit 11
;