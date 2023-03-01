USE master;

CREATE DATABASE [restaurant];
GO

USE [restaurant];

CREATE TABLE [dish] (
	[id_dish] INT PRIMARY KEY IDENTITY(1, 1), 
	[title] VARCHAR(30) NOT NULL,
	[description] VARCHAR(255) NULL, 
	[price] DECIMAL NOT NULL
);

CREATE TABLE [product] (
	[id_product] INT PRIMARY KEY IDENTITY(1, 1), 
	[name] VARCHAR(30) NOT NULL
);

CREATE TABLE [recipe] (
	[id_recipe] INT PRIMARY KEY IDENTITY(1, 1), 
	[id_dish] INT FOREIGN KEY REFERENCES [dish]([id_dish]) NOT NULL,
	[instruction] VARCHAR(max) NOT NULL, 
	[author] VARCHAR(30) NULL
);

CREATE TABLE [recipe_product] (
	[id_recipe_product] INT PRIMARY KEY IDENTITY(1, 1), 
	[id_product] INT FOREIGN KEY REFERENCES [product]([id_product]) NOT NULL, 
	[id_recipe] INT FOREIGN KEY REFERENCES [recipe]([id_recipe]) NOT NULL, 
	[count] INT NOT NULL
);

CREATE TABLE [waiter] (
	[id_waiter] INT PRIMARY KEY IDENTITY(1, 1), 
	[name] VARCHAR(30) NOT NULL, 
	[phone_number] VARCHAR(15) NOT NULL, 
	[sex] TINYINT NOT NULL
);

CREATE TABLE [order] (
	[id_order] INT PRIMARY KEY IDENTITY(1, 1),
	[date] DATETIME NOT NULL, 
	[id_waiter] INT FOREIGN KEY REFERENCES [waiter]([id_waiter]) NOT NULL,
	[total_price] DECIMAL NOT NULL -- Includes discounts and special offers
);

CREATE TABLE [order_dish] (
	[id_order_dish] INT PRIMARY KEY IDENTITY(1, 1),
	[id_dish] INT FOREIGN KEY REFERENCES [dish]([id_dish]) NOT NULL,
	[id_order] INT FOREIGN KEY REFERENCES [order]([id_order]) NOT NULL, 
	[price] DECIMAL NOT NULL -- Price at the moment of ordering 
);