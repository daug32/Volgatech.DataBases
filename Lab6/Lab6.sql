USE [pharmacy]

-- 1) �������� ������� ����� 
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

-- 2) ������ ���������� �� ���� ������� ��������� ��������� �������� ������ � ��������� �������� �����, ���, ������ �������.

	SELECT
		[pharmacy].[name] AS '������',
		[order].[date] AS '���� ������',
		[order].[quantity] AS '����� ������'
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
		[medicine].[name] = '��������' AND
		[company].[name] = '�����'

-- 3) ���� ������ �������� �������� �������, �� ������� �� ���� ������� ������ �� 25 ������

	SELECT 
		[medicine].[name] AS '���������'
	FROM [medicine]
	JOIN [production]
		ON [medicine].[id_medicine] = [production].[id_medicine]
	JOIN [company]
		ON [production].[id_company] = [company].[id_company] AND
		[company].[name] = '�����'
	LEFT JOIN [order]
		ON [production].[id_production] = [order].[id_production] AND
		[order].[date] < '2019-01-25'
	WHERE [order].[id_order] IS NULL;

-- 4) ���� ����������� � ������������ ����� �������� ������ �����, ������� �������� �� ����� 120 �������

	SELECT 
		[company].[name],
		MAX([production].[rating]) AS '���������� ����',
		MIN([production].[rating]) AS '���������� ����'
	FROM [company]
	JOIN [production] 
		ON [company].[id_company] = [production].[id_company]
	JOIN [order]
		ON [production].[id_production] = [order].[id_production]
	GROUP BY [company].[name] 
	HAVING COUNT([order].[id_order]) >= 120;

-- 5) ���� ������ ��������� ������ ����� �� ���� ������� �������� �AstraZeneca�. ���� � ������ ��� �������, � �������� ������ ���������� NULL.

	SELECT
		[dealer].[name] AS '�����', 
		[pharmacy].[name] AS '������'
	FROM [dealer]
	LEFT JOIN [order]
		ON [dealer].[id_dealer] = [order].[id_dealer]
	LEFT JOIN [company]
		ON [dealer].[id_company] = [company].[id_company]
	LEFT JOIN [pharmacy]
		ON [order].[id_pharmacy] = [pharmacy].[id_pharmacy]
	WHERE [company].[name] = 'AstraZeneca'
	ORDER BY [dealer].[name]

-- 6) ��������� �� 20% ��������� ���� ��������, ���� ��� ��������� 3000, � ������������ ������� �� ����� 7 ����.

	SELECT [production].[price] AS '����� ����'
	--UPDATE [production]
	--SET [production].[price] = [production].[price] * 0.8 
	FROM [production]
	JOIN [medicine] 
		ON [production].[id_medicine] = [medicine].[id_medicine]
	WHERE
		[production].[price] > 3000 AND
		[medicine].[cure_duration] <= 7

-- 7) �������� ����������� �������

	-- order, ���������� 999
		-- ������ ������
		-- ����� ������������: id_production
	-- production, ���������� 168
		-- ������ ������
		-- ����� ������������: id_medicine
	-- medicine, ���������� 21
		-- ������ ��������/��������
	-- pharmacy, ���������� 25
		-- ������ ��������/��������
	-- dealer, ���������� 85
		-- ������ ��������/��������
	-- company, ���������� 8
		-- ������ ��������

	-- 1) Order'�� �����, 2) Join �� order-production ������������ �����
	CREATE INDEX [IX_order_id_production] ON [order] ([id_production])
	-- ����� �� ������������ ����? �� ������ � ������� 
	-- CREATE INDEX [IX_order_date] ON [order] ([date])

	-- 1) Production ������������ �����, 2) Join �� production-medicine ������������ �����
	CREATE INDEX [IX_production_id_medicine] ON [production] ([id_medicine])

	-- ����� ���������� �� ����� ��������. �.�., ��������, ���������� ���������� �������� ��� ��� ����������, �� ����� � ������ ��������� 
	-- cure_duration ����� ����������� � ��������� �������� (� ������ ������ -- ��������� ���������)
	CREATE INDEX [IX_medicine_cure_duration] ON [medicine] ([cure_duration])

	-- ����� ���������� �� ����� ��������: 
		-- 1) ��������, ��������, ����� ����������� ����� ������� ��������
		-- 2) ������ ����������� � ������ ������ ��� � �����
	-- �� �������� ����������, ��������, ����� ����������� ����� 
	CREATE INDEX [IX_pharmacy_rating] ON [pharmacy] ([rating])

	-- 1) ������ �� ����� ������, 2) ���� �����, ��������, ����� �������������� � Join'�� dealer-company
	CREATE INDEX [IX_dealer_id_company] ON [dealer] ([id_company])


