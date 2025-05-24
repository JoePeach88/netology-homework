[🔙 на главную](https://github.com/YeezyWhy/netology-homework/tree/main)

# Домашнее задание по теме "SQL. Часть 1". Гаев Егор

## Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.

## Решение

```sql
SELECT district from sakila.address a
WHERE district like 'k%a' and district not like '% %';
```

![alt text](/img/img1.png)

## Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.

## Решение

```sql
SELECT * from sakila.payment p 
where payment_date BETWEEN '2005-06-15 00:00:00' and '2005-06-18 23:59:59' and amount > '10,00';
```

![alt text](/img/img2.png)

## Задание 3

Получите последние пять аренд фильмов.

## Решение
```sql
SELECT * from sakila.rental r 
order by rental_date desc 
limit 5;
```

![alt text](/img/img3.png)

## Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.

## Решение

```sql
SELECT customer_id, store_id, Lower(REPLACE(first_name, 'L','P')) First_Name, lower(last_name) Last_name, email FROM sakila.customer c 
WHERE active = 1 AND first_name = 'Kelly' or first_name = 'Willie'
```

![alt text](/img/img4.png)
