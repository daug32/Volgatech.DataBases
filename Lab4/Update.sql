USE [housing_taxes]

-- 3.3 UPDATE
-- a) Обвноить все записи
	UPDATE [apartament]
	SET [owner_passport] = '0000000000'

-- b) По условию обновить 1 атрибут
	UPDATE [apartament]
	SET [owner_passport] = '0000000001'
	WHERE [id_apartament] = 1

-- c) По условию обновить несколько атрибутов
	UPDATE [apartament]
	SET
		[number] = 3,
		[owner_passport] = '0000000003'
	WHERE [id_apartament] = 3