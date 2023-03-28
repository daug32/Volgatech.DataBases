USE [housing_taxes]

-- 3.6 ������ � ������
-- a) WHERE �� ����
	SELECT *
	FROM [payment]
	WHERE [date] = '2022-03-28'

-- b) WHERE ���� � ���������
	-- ������� ���� ���� ��������� �� ��������
	UPDATE [payment]
	SET [date] = '2040-01-01'
	WHERE [id_payment] = 1

	-- ������� ���� �� ���������
	SELECT *
	FROM [payment]
	WHERE [date] < GETDATE()

-- c) ������� ������ ��� � �������������� ������� YEAR
	SELECT
		[id_payment],
		[total_price],
		YEAR([date])
	FROM [payment]