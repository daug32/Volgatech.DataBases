USE [housing_taxes]

-- 3.2 DELETE
-- a) ������� ��� ������
	DELETE 
	FROM [utility_tariff]

-- b) ������� �� �������
	DELETE 
	FROM [apartament]
	WHERE [apartament].[id_apartament] % 2 = 0