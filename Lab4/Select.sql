USE [housing_taxes]

-- 3.4 SELECT 
-- a) — набором извлекаемых атрибутов 
	SELECT 
		[id_apartament], 
		[owner_passport]
	FROM [apartament]

-- b) —о всеми атрибутами 
	SELECT *
	FROM [apartament]

-- c) — условием по атрибуту
	SELECT *
	FROM [apartament]
	WHERE [id_house] = 2


-- 3.5 SELECT ORDER BY + TOP(LIMIT)
-- a) — сортировкой по возрастанию + ограничение вывода количества записей
	SELECT TOP(2) *
	FROM [utility_tariff]
	ORDER BY [price]

-- b) — сортировкой по убыванию 
	SELECT *
	FROM [utility_tariff]
	ORDER BY [price] DESC

-- c) — сортировкой по 2 атрибутам + ограничение вывода количества записей
	SELECT TOP(2) *
	FROM [utility_tariff]
	ORDER BY tariff_type DESC, [price]

-- d) — сортировкой по первому атрибуту из списка извлекаемых
	SELECT
		[tariff_type],
		[price]
	FROM [utility_tariff]
	ORDER BY [tariff_type] DESC, [price]
	