USE [housing_taxes]

-- 3.6 Работа с датами
-- a) WHERE по дате
	SELECT *
	FROM [payment]
	WHERE [date] = '2022-03-28'

-- b) WHERE дата в диапазоне
	-- Сделать одну дату выходящей из дипазона
	UPDATE [payment]
	SET [date] = '2040-01-01'
	WHERE [id_payment] = 1

	-- Извлечь даты по диапазону
	SELECT *
	FROM [payment]
	WHERE [date] < GETDATE()

-- c) Извлечь только год с использованием функции YEAR
	SELECT
		[id_payment],
		[total_price],
		YEAR([date])
	FROM [payment]