USE [housing_taxes]

-- 3.7 Функции агрегации 
-- a) Посчитать количество записей в таблице
	SELECT COUNT(*)
	FROM [apartament]

-- b) Посчитать количество уникальных записей в таблице
	SELECT COUNT(DISTINCT [date])
	FROM [payment]

-- c) Вывести уникальные значения столбца
	SELECT [date]
	FROM [payment]
	GROUP BY [date]

-- d) Найти максимальное значение столбца
	SELECT MAX([date])
	FROM [payment]

-- e) Найти минимальное значение столбца
	SELECT MIN([date])
	FROM [payment]

-- f) Написать запрос COUNT() + GROUP BY
	SELECT
		COUNT(*) AS 'Number of transactions at the date',
		[date]
	FROM [payment]
	GROUP BY [date]


-- 3.8 SELECT GROUP BY + HAVING
-- a) Написть 3 запроса с функциями выше. Написать пояснения к ним о том, что выводят

	-- Выводит дома с низкой ценой проживания
	SELECT 
		[id_house], 
		AVG([price]) AS 'Average "price of living" in house'
	FROM [utility_tariff]
	GROUP BY [id_house]
	HAVING AVG([price]) < 50

	-- Выводит даты, в которые было проведено транзакций на сумму, как минимум, в 600 условных единиц
	SELECT 
		[date],
		SUM([total_price]) AS 'Summary of all transactions at the date'
	FROM [payment]
	GROUP BY [date]
	HAVING SUM([total_price]) > 600

	-- Вывод информацию о самых дешевых тарифах
	SELECT
		[tariff_type],
		AVG([price]) AS 'Average tariff price'
	FROM [utility_tariff]
	GROUP BY [tariff_type]
	HAVING AVG([price]) < 30