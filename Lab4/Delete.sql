USE [housing_taxes]

-- 3.2 DELETE
-- a) Удалить все записи
	DELETE 
	FROM [utility_tariff]

-- b) Удалить по условию
	DELETE 
	FROM [apartament]
	WHERE [apartament].[id_apartament] % 2 = 0