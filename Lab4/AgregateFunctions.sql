USE [housing_taxes]

-- 3.7 ������� ��������� 
-- a) ��������� ���������� ������� � �������
	SELECT COUNT(*)
	FROM [apartament]

-- b) ��������� ���������� ���������� ������� � �������
	SELECT COUNT(DISTINCT [date])
	FROM [payment]

-- c) ������� ���������� �������� �������
	SELECT [date]
	FROM [payment]
	GROUP BY [date]

-- d) ����� ������������ �������� �������
	SELECT MAX([date])
	FROM [payment]

-- e) ����� ����������� �������� �������
	SELECT MIN([date])
	FROM [payment]

-- f) �������� ������ COUNT() + GROUP BY
	SELECT
		COUNT(*) AS 'Number of transactions at the date',
		[date]
	FROM [payment]
	GROUP BY [date]


-- 3.8 SELECT GROUP BY + HAVING
-- a) ������� 3 ������� � ��������� ����. �������� ��������� � ��� � ���, ��� �������

	-- ������� ���� � ������ ����� ����������
	SELECT 
		[id_house], 
		AVG([price]) AS 'Average "price of living" in house'
	FROM [utility_tariff]
	GROUP BY [id_house]
	HAVING AVG([price]) < 50

	-- ������� ����, � ������� ���� ��������� ���������� �� �����, ��� �������, � 600 �������� ������
	SELECT 
		[date],
		SUM([total_price]) AS 'Summary of all transactions at the date'
	FROM [payment]
	GROUP BY [date]
	HAVING SUM([total_price]) > 600

	-- ����� ���������� � ����� ������� �������
	SELECT
		[tariff_type],
		AVG([price]) AS 'Average tariff price'
	FROM [utility_tariff]
	GROUP BY [tariff_type]
	HAVING AVG([price]) < 30