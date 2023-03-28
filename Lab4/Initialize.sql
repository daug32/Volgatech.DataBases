USE master
CREATE DATABASE [housing_taxes]
GO

USE [housing_taxes];

CREATE TABLE [region] (
	[id_region] INT PRIMARY KEY, 
	[name] NVARCHAR(255) NOT NULL,
	[GMT] INT NOT NULL, 
	[region_type] TINYINT NOT NULL
);

CREATE TABLE [house] (
	[id_house] INT PRIMARY KEY IDENTITY(1, 1),
	[name] NVARCHAR(255) NOT NULL,
	[id_region] INT NOT NULL
		FOREIGN KEY REFERENCES [region] ([id_region])
		ON DELETE CASCADE,
	[house_type] TINYINT NOT NULL,
	[latitude] DECIMAL NULL, 
	[longitude] DECIMAL NULL
);

CREATE TABLE [utility_tariff] (
	[id_utility_tariff] INT PRIMARY KEY IDENTITY(1, 1),
	[tariff_type] TINYINT NOT NULL,
	[id_house] INT NOT NULL
		FOREIGN KEY REFERENCES [house] ([id_house])
		ON DELETE CASCADE,
	[price] DECIMAL NOT NULL
);

CREATE TABLE [apartament](
	[id_apartament] INT PRIMARY KEY IDENTITY(1, 1),
	[number] INT NOT NULL,
	[id_house] INT NOT NULL
		FOREIGN KEY REFERENCES [house] ([id_house])
		ON DELETE CASCADE,
	[owner_passport] NVARCHAR (10) NOT NULL
);

CREATE TABLE [payment] (
	[id_payment] INT PRIMARY KEY IDENTITY(1, 1), 
	[date] DATETIME2 NOT NULL, 
	[id_utility_tariff] INT NULL
		FOREIGN KEY REFERENCES [utility_tariff] ([id_utility_tariff])
		ON DELETE SET NULL,
	[id_apartament] INT NULL
		FOREIGN KEY REFERENCES [apartament] ([id_apartament])
		ON DELETE NO ACTION,
	[total_price] DECIMAL NOT NULL
);
