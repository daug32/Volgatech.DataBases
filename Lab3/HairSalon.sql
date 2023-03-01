USE master;

CREATE DATABASE [hair_salon];
GO

USE [hair_salon];

CREATE TABLE [hairdresser] (
	[id_hairdresser] INT PRIMARY KEY IDENTITY(1, 1), 
	[name] VARCHAR(30) NOT NULL,
	[phone_number] VARCHAR(15) NOT NULL, 
	[sex] TINYINT NOT NULL
);

CREATE TABLE [service] (
	[id_service] INT PRIMARY KEY IDENTITY(1, 1),
	[title] VARCHAR(30) NOT NULL, 
	[description] VARCHAR(255) NULL, 
	[price] DECIMAL NOT NULL -- Raw price without discounts
);

CREATE TABLE [customer] (
	[id_customer] INT PRIMARY KEY IDENTITY(1, 1), 
	[name] VARCHAR(30) NOT NULL, 
	[phone_number] VARCHAR(15) NOT NULL, 
	[email] VARCHAR(320) NULL
);

CREATE TABLE [order] (
	[id_order] INT PRIMARY KEY IDENTITY(1, 1),
	[id_hairdresser] INT FOREIGN KEY REFERENCES [hairdresser]([id_hairdresser]) NOT NULL, 
	[id_customer] INT FOREIGN KEY REFERENCES [customer]([id_customer]) NOT NULL, 
	[id_service] INT FOREIGN KEY REFERENCES [service]([id_service]) NOT NULL, 
	[total_price] DECIMAL NOT NULL -- Includes discounts and special offers
);

CREATE TABLE [notification_subscription] (
	[id_notification_subscription] INT PRIMARY KEY IDENTITY(1, 1), 
	[id_customer] INT FOREIGN KEY REFERENCES [customer]([id_customer]) NOT NULL,
	[id_subscription_type] TINYINT NOT NULL, -- F.e. SubscriptionType.NewServices, SubscriptionType.Discounts or SubscriptionType.NewSalons
	[id_notification_type] TINYINT NOT NULL, -- F.e. NotificationType.Email, NotificationType.Telegram or NotificationType.Facebook
	[contacts_info] VARCHAR(255) NOT NULL    -- F.e. email, telegram id or facebook id
);