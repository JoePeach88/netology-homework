[🔙 на главную](https://github.com/YeezyWhy/netology-homework/tree/main)

# Домашнее задание по теме "SQL. Часть 2". Гаев Егор

## Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.

## Решение

```sql
SELECT s.first_name, s.last_name, c2.city , s.staff_id, count(c.customer_id)
from sakila.staff s 
join store s2 ON s.store_id = s2.store_id 
JOIN customer c on c.store_id  = s2.store_id 
join address a on a.address_id = s2.address_id 
join city c2 on a.city_id = c2.city_id 
GROUP BY s.staff_id, c2.city_id 
HAVING count(c.customer_id) > 300;
```

![alt text](/img/img1.png)

## Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

## Решение

```sql
SELECT COUNT(f.title)
from sakila.film f 
where `length` > 
	(SELECT AVG(`length`)
	from sakila.film )
```

![alt text](/img/img2.png)

## Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

## Решение

```sql
SELECT DATE_FORMAT(p.payment_date, '%Y-%M') AS Дата , (sum(p.amount )) AS Сумма , count((p.rental_id )) AS Аренд
FROM sakila.payment p 
GROUP BY Дата
ORDER BY Сумма DESC
LIMIT 1;
```

![alt text](/img/img3.png)
