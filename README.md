[🔙 на главную](https://github.com/YeezyWhy/netology-homework/tree/main)

# Домашнее задание по теме "Индексы". Гаев Егор

## Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

## Решение

```sql
SELECT CONCAT(ROUND(SUM(INDEX_LENGTH) / SUM(DATA_LENGTH) * 100, 1), '%') FROM information_schema.TABLES
```

![alt text](/img/img1.png)

## Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.

## Решение

Исходный запрос

```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from sakila.payment p, sakila.rental r, sakila.customer c, sakila.inventory i, sakila.film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```

![alt text](/img/img2.png)

Оптимизированный

```sql
SELECT DISTINCT 
    CONCAT(c.last_name, ' ', c.first_name) AS customer_name,
    SUM(p.amount) OVER (PARTITION BY c.customer_id, f.title) AS total_amount_per_film
FROM sakila.payment p
JOIN sakila.rental r ON p.payment_date = r.rental_date
JOIN sakila.customer c ON r.customer_id = c.customer_id
JOIN sakila.inventory i ON i.inventory_id = r.inventory_id
JOIN sakila.film f ON f.film_id = i.film_id
WHERE p.payment_date >= '2005-07-30 00:00:00'
  AND p.payment_date < '2005-07-31 00:00:00';
```

![alt text](/img/img3.png)

Что изменено:

* Использован явный JOIN вместо старого синтаксиса с запятыми.

* Добавлено условие f.film_id = i.film_id, чтобы корректно связать фильмы с инвентарём.

* Убрана функция date() из условия фильтрации, вместо этого используется диапазон дат — это позволит эффективно использовать индекс по payment_date.
