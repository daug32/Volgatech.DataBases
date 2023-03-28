USE [housing_taxes]

-- 3.9 SELECT JOIN 
-- a) LEFT JOIN двух таблиц и WHERE по одному из атрибутов
	SELECT *
	FROM [apartament] AS a
	LEFT JOIN [payment] AS p
		ON p.[id_apartament] = a.[id_apartament]
	WHERE a.[owner_passport] != '0000000000'

-- b) RIGHT JOIN. Получить такую же выборку, как и в 3.9 a 
	SELECT *
	FROM [payment] AS p
	RIGHT JOIN [apartament] AS a
		ON p.[id_apartament] = a.[id_apartament]
	WHERE a.[owner_passport] != '0000000000'

-- c) LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
	SELECT 
		a.[number]		   AS 'Apartament"s number',
		a.[owner_passport] AS 'Owner passport',
		ut.[tariff_type]   AS 'Tariff type',
		ut.[price]		   AS 'Tariff price',
		p.[total_price]	   AS 'Total price',
		p.[date]		   AS 'Transacation date'
	FROM [apartament] AS a
	LEFT JOIN [utility_tariff] AS ut
		ON a.[id_house] = ut.[id_house]
	LEFT JOIN [payment] AS p 
		ON p.[id_apartament] = a.[id_apartament]
	WHERE 
		a.[owner_passport] != '0000000000'
		AND ut.[tariff_type] IN (2, 4, 10)
		AND p.[date] = '2022-03-28'

-- d) INNER JOIN двух таблиц
	SELECT 
		r.*,
		h.[id_house]
	FROM [Region] AS r
	JOIN [house] AS h
		ON h.[id_region] = r.[id_region]
	WHERE h.[house_type] = 1
	ORDER BY 
		r.[id_region],
		h.[id_house]


-- Подзапросы 
-- a) Написать запрос с условием WHERE IN (подзапрос)
	SELECT *
	FROM [utility_tariff]
	WHERE [id_house] IN (1, 3)

-- b) Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
	SELECT 
		[id_utility_tariff], 
		[tariff_type], 
		[price], 
		(
			SELECT ISNULL(AVG([total_price]), 0)
			FROM [payment]
			WHERE [payment].[id_utility_tariff] = [utility_tariff].[id_utility_tariff]
		) AS 'Average total price'
	FROM [utility_tariff]
	ORDER BY
		'Average total price' DESC,
		[id_utility_tariff];

-- c) Написать запрос вида SELECT * FROM (подзапрос)
	SELECT *
	FROM 
	(
		SELECT r.[id_region], COUNT(h.id_house) as 'houses_number'
		FROM [region] AS r
		JOIN [house] AS h
			ON r.[id_region] = h.[id_region]
		GROUP BY r.[id_region]
	) AS region_houses

-- d) Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON ...
	SELECT 
		h.[id_house], 
		h.[name], 
		tariff_prices.[average_total_payment]
	FROM [house] AS h
	JOIN 
	(
		SELECT
			ut.[id_house],
			ISNULL(AVG(p.[total_price]), 0) AS 'average_total_payment'
		FROM [utility_tariff] AS ut
		LEFT JOIN [payment] AS p
			ON p.[id_utility_tariff] = ut.[id_utility_tariff]
		GROUP BY ut.[id_house]
	) AS tariff_prices
		ON tariff_prices.[id_house] = h.[id_house]