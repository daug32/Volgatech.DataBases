USE [pharmacy]

-- 1) Добавить внешние ключи 
	-- dbo.dealer
	IF NOT EXISTS (SELECT TOP(1) 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='FK_dealer_company')
	ALTER TABLE [dealer]
		ADD CONSTRAINT [FK_dealer_company]
			FOREIGN KEY ([id_company])
			REFERENCES [dbo].[company] ([id_company])
	GO
	
	-- dbo.order
	IF NOT EXISTS (SELECT TOP(1) 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='FK_order_production')
	ALTER TABLE [order]
		ADD CONSTRAINT [FK_order_production]
			FOREIGN KEY ([id_production])
			REFERENCES [dbo].[production] ([id_production])
		
	IF NOT EXISTS (SELECT TOP(1) 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='FK_order_dealer')
	ALTER TABLE [order]
		ADD CONSTRAINT [FK_order_dealer]
			FOREIGN KEY ([id_dealer])
			REFERENCES [dbo].[dealer] ([id_dealer])
		
	IF NOT EXISTS (SELECT TOP(1) 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='FK_order_pharmacy')
	ALTER TABLE [order]
		ADD CONSTRAINT [FK_order_pharmacy]
			FOREIGN KEY ([id_pharmacy])
			REFERENCES [dbo].[pharmacy] ([id_pharmacy])
	GO

	-- dbo.production
	IF NOT EXISTS (SELECT TOP(1) 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='FK_production_company')
	ALTER TABLE [production]
		ADD CONSTRAINT [FK_production_company]
			FOREIGN KEY ([id_company])
			REFERENCES [dbo].[company] ([id_company])
		
	IF NOT EXISTS (SELECT TOP(1) 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='FK_production_medicine')
	ALTER TABLE [production]
		ADD CONSTRAINT [FK_production_medicine]
			FOREIGN KEY ([id_medicine])
			REFERENCES [dbo].[medicine] ([id_medicine])
	GO

-- 2) Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с указанием названий аптек, дат, объема заказов.

	SELECT
		[pharmacy].[name] AS 'Аптека',
		[order].[date] AS 'Дата заказа',
		[order].[quantity] AS 'Объем заказа'
	FROM [order]
	JOIN [pharmacy]
		ON [order].[id_pharmacy] = [pharmacy].[id_pharmacy]
	JOIN [production]
		ON [order].[id_production] = [production].[id_production]
	JOIN [medicine]
		ON [production].[id_medicine] = [medicine].[id_medicine]
	JOIN [company]
		ON [production].[id_company] = [company].[id_company]
	WHERE
		[medicine].[name] = 'Кордерон' AND
		[company].[name] = 'Аргус'

-- 3) Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января

	SELECT 
		[medicine].[name] AS 'Лекарство'
	FROM [medicine]
	JOIN [production]
		ON [medicine].[id_medicine] = [production].[id_medicine]
	JOIN [company]
		ON [production].[id_company] = [company].[id_company] AND
		[company].[name] = 'Фарма'
	LEFT JOIN [order]
		ON [production].[id_production] = [order].[id_production] AND
		[order].[date] < '2019-01-25'
	WHERE [order].[id_order] IS NULL;

-- 4) Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов

	SELECT 
		[company].[name],
		MAX([production].[rating]) AS 'Наибольший балл',
		MIN([production].[rating]) AS 'Наименьший балл'
	FROM [company]
	JOIN [production] 
		ON [company].[id_company] = [production].[id_company]
	JOIN [order]
		ON [production].[id_production] = [order].[id_production]
	GROUP BY [company].[name] 
	HAVING COUNT([order].[id_order]) >= 120;

-- 5) Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”. Если у дилера нет заказов, в названии аптеки проставить NULL.

	SELECT
		[dealer].[name] AS 'Дилер', 
		[pharmacy].[name] AS 'Аптека'
	FROM [dealer]
	LEFT JOIN [order]
		ON [dealer].[id_dealer] = [order].[id_dealer]
	LEFT JOIN [company]
		ON [dealer].[id_company] = [company].[id_company]
	LEFT JOIN [pharmacy]
		ON [order].[id_pharmacy] = [pharmacy].[id_pharmacy]
	WHERE [company].[name] = 'AstraZeneca'
	ORDER BY [dealer].[name]

-- 6) Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.

	SELECT [production].[price] AS 'Новая цена'
	--UPDATE [production]
	--SET [production].[price] = [production].[price] * 0.8 
	FROM [production]
	JOIN [medicine] 
		ON [production].[id_medicine] = [medicine].[id_medicine]
	WHERE
		[production].[price] > 3000 AND
		[medicine].[cure_duration] <= 7

-- 7) Добавить необходимые индексы

	-- order, количество 999
		-- Растет быстро
		-- Часто используется: id_production
	-- production, количество 168
		-- Растет быстро
		-- Часто используется: id_medicine
	-- medicine, количество 21
		-- Растет медленно/умеренно
	-- pharmacy, количество 25
		-- Растет медленно/умеренно
	-- dealer, количество 85
		-- Растет медленно/умеренно
	-- company, количество 8
		-- Растет медленно

	-- 1) Order'ов много, 2) Join на order-production используется часто
	CREATE INDEX [IX_order_id_production] ON [order] ([id_production])
	-- Часто ли используются даты? Не уверен в индексе 
	-- CREATE INDEX [IX_order_date] ON [order] ([date])

	-- 1) Production относительно много, 2) Join на production-medicine используется часто
	CREATE INDEX [IX_production_id_medicine] ON [production] ([id_medicine])

	-- Время обновления не имеет значения. Т.к., вероятно, добавление происходит бизнесом или тех поддержкой, то можно и минуту подождать 
	-- cure_duration будет участвовать в поисковых запросах (в худшем случае -- конечными клиентами)
	CREATE INDEX [IX_medicine_cure_duration] ON [medicine] ([cure_duration])

	-- Время обновления не имеет значения: 
		-- 1) Рейтинги, вероятно, будут обновляться ночью фоновым сервисом
		-- 2) Аптеки добавляются в худшем случае раз в месяц
	-- По рейтингу фильтрация, вероятно, будет происходить часто 
	CREATE INDEX [IX_pharmacy_rating] ON [pharmacy] ([rating])

	-- 1) Растет не особо быстро, 2) чаще всего, вероятно, будет использоваться в Join'ах dealer-company
	CREATE INDEX [IX_dealer_id_company] ON [dealer] ([id_company])


