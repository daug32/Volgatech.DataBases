USE [housing_taxes]

-- 3.4 SELECT 
-- a) � ������� ����������� ��������� 
	SELECT 
		[id_apartament], 
		[owner_passport]
	FROM [apartament]

-- b) �� ����� ���������� 
	SELECT *
	FROM [apartament]

-- c) � �������� �� ��������
	SELECT *
	FROM [apartament]
	WHERE [id_house] = 2


-- 3.5 SELECT ORDER BY + TOP(LIMIT)
-- a) � ����������� �� ����������� + ����������� ������ ���������� �������
	SELECT TOP(2) *
	FROM [utility_tariff]
	ORDER BY [price]

-- b) � ����������� �� �������� 
	SELECT *
	FROM [utility_tariff]
	ORDER BY [price] DESC

-- c) � ����������� �� 2 ��������� + ����������� ������ ���������� �������
	SELECT TOP(2) *
	FROM [utility_tariff]
	ORDER BY tariff_type DESC, [price]

-- d) � ����������� �� ������� �������� �� ������ �����������
	SELECT
		[tariff_type],
		[price]
	FROM [utility_tariff]
	ORDER BY [tariff_type] DESC, [price]
	