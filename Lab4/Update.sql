USE [housing_taxes]

-- 3.3 UPDATE
-- a) �������� ��� ������
	UPDATE [apartament]
	SET [owner_passport] = '0000000000'

-- b) �� ������� �������� 1 �������
	UPDATE [apartament]
	SET [owner_passport] = '0000000001'
	WHERE [id_apartament] = 1

-- c) �� ������� �������� ��������� ���������
	UPDATE [apartament]
	SET
		[number] = 3,
		[owner_passport] = '0000000003'
	WHERE [id_apartament] = 3