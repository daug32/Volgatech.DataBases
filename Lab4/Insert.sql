USE [housing_taxes]

-- 3.1 INSERT 
-- a) ��� �������� ������ �����. � ����� � ���� ������������� Id'����� ��������
	-- ������� ��� ������� ������ ����� � ������ ������� ������
	-- <id>, <name>, <GMT>, <region type>
	INSERT INTO [Region]
	VALUES 
		(1, 'Region 1 name',  0, 4),
		(2, 'Region 2 name',  3, 1),
		(3, 'Region 3 name', -2, 1);
	GO

-- b) � ��������� ������ �����
	-- ������� ��� "�����" ���� � ���� ��������� ��������
	INSERT INTO [House] ([name], [id_region], [house_type], [latitude], [longitude])
	VALUES 
		('House 1 name', 1, 1, null, null),
		('House 2 name', 2, 1, 56.630733, 47.892071),
		('House 3 name', 1, 1, 56.631347, 47.889466);
	GO

	 -- ������� �� 2 ������� � ������ ����
	INSERT INTO [Apartament] ([number], [id_house], [owner_passport])
	VALUES 
		(100, 1, '0000000000'),
		(101, 1, '0000000001'),
		(100, 2, '0000000002'),
		(101, 2, '0000000003'),
		(100, 3, '0000000004'),
		(101, 3, '0000000005');
	GO
	
	-- ������� �� ��� ������ ��� ������� ����
	INSERT INTO [utility_tariff] ([tariff_type], [id_house], [price])
	VALUES 
		(1, 1, 0.7),
		(2, 1, 63.3),
		(1, 2, 61),
		(2, 2, 10),
		(1, 3, 0.3),
		(2, 3, 100)
	GO

-- c) � ������� �������� � ������ �������
	-- ������� 3 ������� ��� ����� �������� �� ������� �������
	INSERT INTO [payment] (
		[date],
		[id_utility_tariff],
		[id_apartament],
		[total_price])
	SELECT 
		'2022-03-28 00:00:00',
		tariff.[id_utility_tariff],
		[apartament].[id_apartament],
		tariff.[price] * 10
	FROM [utility_tariff] AS tariff
	JOIN [apartament] 
		ON [apartament].[id_house] = tariff.[id_house]
	WHERE [apartament].[id_apartament] = 1
