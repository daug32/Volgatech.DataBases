USE [hotel_lab5]
USE [hotel_lab5]

-- 1) Добавить внешние ключи 
	-- Room
	ALTER TABLE [dbo].[room]
		ADD CONSTRAINT [FK_room_hotel]
			FOREIGN KEY ([id_hotel])
			REFERENCES [dbo].[hotel] ([id_hotel])
			ON UPDATE CASCADE
			ON DELETE CASCADE

	ALTER TABLE [dbo].[room]
		ADD CONSTRAINT [FK_room_room_category]
			FOREIGN KEY ([id_room_category])
			REFERENCES [dbo].[room_category] ([id_room_category])
			ON UPDATE CASCADE
			ON DELETE CASCADE
	GO

	-- Room in booking
	ALTER TABLE [dbo].[room_in_booking] 
		ADD CONSTRAINT [FK_room_in_booking_room]
			FOREIGN KEY ([id_room]) 
			REFERENCES [dbo].[room] ([id_room])
			ON UPDATE CASCADE
			ON DELETE CASCADE

	ALTER TABLE [dbo].[room_in_booking] 
		ADD CONSTRAINT [FK_room_in_booking_booking]
			FOREIGN KEY ([id_booking]) 
			REFERENCES [dbo].[booking] ([id_booking])
			ON UPDATE CASCADE
			ON DELETE CASCADE
	GO
	
	-- Booking
	ALTER TABLE [dbo].[booking] 
		ADD CONSTRAINT [FK_client_booking]
			FOREIGN KEY ([id_client]) 
			REFERENCES [dbo].[Client] ([id_client])
			ON UPDATE CASCADE
			ON DELETE CASCADE
	GO

-- 2) Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г
	DECLARE @TargetDate DATE
	SET @TargetDate = '2019-04-01'

	SELECT [client].*
	FROM [client]
	JOIN [booking]
		ON [booking].[id_client] = [client].[id_client]
	JOIN [room_in_booking] 
		ON [room_in_booking].[id_booking] = [booking].[id_booking]
	JOIN [room] 
		ON [room].[id_room] = [room_in_booking].[id_room]
	JOIN [room_category]
		ON [room_category].[id_room_category] = [room].[id_room_category]
	WHERE 
		[room_category].[name] = 'Люкс' AND
		@TargetDate BETWEEN
			[room_in_booking].[checkin_date] AND
			[room_in_booking].[checkout_date] 
	GO


-- 3) Дать список свободных номеров всех гостиниц на 22 апреля
	-- Получить все забронированные комнаты на указанный день
	DECLARE @TargetDate DATE
	SET @TargetDate = '2019-04-22'

	IF OBJECT_ID('tempdb..[#reserved_rooms]') IS NOT NULL
		DROP TABLE [#reserved_rooms]

	CREATE TABLE #reserved_rooms (
		[id_room] INT
	)

	INSERT INTO [#reserved_rooms]
	SELECT [room].[id_room]
	FROM [room]
	JOIN [room_in_booking] 
		ON [room_in_booking].[id_room] = [room].[id_room]
	WHERE @TargetDate BETWEEN
		[room_in_booking].[checkin_date] AND
		[room_in_booking].[checkout_date] 
	
	-- Получить свободные комнаты в указанный день
	SELECT *
	FROM [room]
	WHERE [room].[id_room] NOT IN (
		SELECT [#reserved_rooms].[id_room] 
		FROM [#reserved_rooms]
	)
	GO


-- 4) Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров
	DECLARE @TargetDate DATE 
	SET @TargetDate = '2019-03-23'

	SELECT 
		COUNT([booking].[id_client]) AS 'Clients amount', 
		[room_category].[name] AS 'Room category name'
		-- , @TargetDate AS 'Booking date'
	FROM [booking]
	JOIN [room_in_booking]
		ON [room_in_booking].[id_booking] = [booking].[id_booking]
	JOIN [room]
		ON [room].[id_room] = [room_in_booking].[id_room]
	JOIN [hotel] 
		ON [hotel].[id_hotel] = [room].[id_hotel]
	JOIN [room_category]
		ON [room_category].[id_room_category] = [room].[id_room_category]
	WHERE 
		[hotel].[name] = 'Космос' AND 
		@TargetDate BETWEEN
			[room_in_booking].[checkin_date] AND
			[room_in_booking].[checkout_date] 
	GROUP BY [room_category].[name]


-- 5) Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда. 
	DECLARE @TargetMonth INT
	SET @TargetMonth = 4

	SELECT 
		MAX([client].[id_client]) AS 'Last client id',
		[room_in_booking].[checkout_date] AS 'Departure date'
	FROM [client]
	JOIN [booking] 
		ON [booking].[id_client] = [client].[id_client]
	JOIN [room_in_booking]
		ON [room_in_booking].[id_booking] = [booking].[id_booking]
	JOIN [room]
		ON [room].[id_room] = [room_in_booking].[id_room]
	JOIN [hotel]
		ON [hotel].[id_hotel] = [room].[id_hotel]
	WHERE 
		[hotel].[name] = 'Космос' AND
		MONTH([room_in_booking].[checkout_date]) = @TargetMonth
	GROUP BY [room_in_booking].[checkout_date]
	ORDER BY 'Departure date'
	USE [hotel_lab5]
	

-- 6) Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая.
	DECLARE @TargetDate DATE
	SET @TargetDate = '2019-05-10'

	DECLARE @ExtraDaysCount INT
	SET @ExtraDaysCount = 2		

	--SELECT *
	--FROM [room_in_booking]
	--JOIN [room] 
	--	ON [room].[id_room] = [room_in_booking].[id_room]
	--JOIN [room_category]
	--	ON [room_category].[id_room_category] = [room].[id_room_category]
	--JOIN [hotel]
	--	ON [hotel].[id_hotel] = [room].[id_hotel]
	--WHERE 
	--	[hotel].[name] = 'Космос' AND
	--	[room_category].[name] = 'Бизнес' AND 
	--	[room_in_booking].[checkin_date] = @TargetDate

	UPDATE [room_in_booking]
	SET [room_in_booking].[checkout_date] = DATEADD(day, @ExtraDaysCount, [room_in_booking].[checkout_date])
	FROM [room_in_booking]
	JOIN [room] 
		ON [room].[id_room] = [room_in_booking].[id_room]
	JOIN [room_category]
		ON [room_category].[id_room_category] = [room].[id_room_category]
	JOIN [hotel]
		ON [hotel].[id_hotel] = [room].[id_hotel]
	WHERE 
		[hotel].[name] = 'Космос' AND
		[room_category].[name] = 'Бизнес' AND 
		[room_in_booking].[checkin_date] = @TargetDate


-- 7) Найти все "пересекающиеся" варианты проживания. 
-- Правильное состояние: 
-- не может быть забронирован один номер на одну дату несколько раз, т.к. нельзя 
-- заселиться нескольким клиентам в один номер. 
-- Записи в таблице room_in_booking с id_room_in_booking = 5 и 2154 являются примером 
-- неправильного состояния, которые необходимо найти. Результирующий кортеж 
-- выборки должен содержать информацию о двух конфликтующих номерах.

	SELECT r1.[id_room_in_booking], r2.[id_room_in_booking]
	FROM [room_in_booking] AS r1
	JOIN [room_in_booking] AS r2
		ON 
			-- where dates are crossing
			(   
				r2.[checkin_date]  BETWEEN r1.[checkin_date] AND r1.[checkout_date] OR 
				r2.[checkout_date] BETWEEN r1.[checkin_date] AND r1.[checkout_date]
			)
			-- exclude duplicates
			AND r1.[id_room_in_booking] != r2.[id_room_in_booking]
	ORDER BY 
		r1.[id_room_in_booking], 
		r2.[id_room_in_booking]

-- 8) Создать бронирование в транзакции.
	-- Settings
	DECLARE @TargetClientId INT
	SET @TargetClientId = 3

	DECLARE @ArrivalDate DATE
	SET @ArrivalDate = '2023-04-28'

	DECLARE @DepartureDate DATE
	SET @DepartureDate = '2023-04-30'

	DECLARE @TargetHotelName NVARCHAR(54)
	SET @TargetHotelName = 'Космос'

	DECLARE @TargetRoomCategory NVARCHAR(64)
	SET @TargetRoomCategory = 'Люкс'

	-- Create booking
	DECLARE @CreatedBookingData TABLE (
		[id_booking] INT 
	);

	INSERT
		INTO [booking] ([booking_date], [id_client]) 
		OUTPUT 
			INSERTED.[id_booking] 
		INTO @CreatedBookingData ([id_booking])
		SELECT
			GETDATE(),
			@TargetClientId

	-- Get room id 
	DECLARE @TargetRoomId INT
	SELECT TOP(1)
		@TargetRoomId = [room].[id_room]
	FROM [hotel]
	JOIN [room]
		ON [room].[id_hotel] = [hotel].[id_hotel]
	JOIN [room_category]
		ON [room_category].[id_room_category] = [room].[id_room_category]
	WHERE	
		[room_category].[name] = @TargetRoomCategory AND
		[hotel].[name] = @TargetHotelName

	IF (@TargetRoomId IS NULL)
	BEGIN
		PRINT 'No available room found'
		RETURN
	END

	-- Add room in booking
	DECLARE @CreateRoomInBookingData TABLE (
		[id_booking] INT,
		[id_room_in_booking] INT 
	);

	INSERT 
		INTO [room_in_booking] ([checkin_date], [checkout_date], [id_booking], [id_room])
		OUTPUT 
			INSERTED.[id_room_in_booking], 
			INSERTED.[id_booking]
		INTO @CreateRoomInBookingData ([id_room_in_booking], [id_booking])
	VALUES
		(@ArrivalDate, @DepartureDate, (SELECT TOP(1) [id_booking] FROM @CreatedBookingData), @TargetRoomId)

	SELECT 
		[id_room_in_booking] AS 'Created room in booking id',
		[id_booking] AS 'Created booking id'
	FROM @CreateRoomInBookingData
