USE [master]
GO

IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'DWNortwind')
  BEGIN
     
    ALTER DATABASE [DWNorthwind] SET  MULTI_USER WITH ROLLBACK IMMEDIATE
    DROP DATABASE [DWNorthwind]
  END
GO

CREATE DATABASE [DWNorthwind] ON  PRIMARY 
( NAME = N'DWNorthwind'
, FILENAME = N'C:\temp\DWNorthwind.mdf' )
 LOG ON 
( NAME = N'DWSales_log'
, FILENAME = N'C:\temp\DWNorthwind_log.LDF' )
GO

--dimensions
USE DWNorthwind
GO

CREATE TABLE DimCustomers(
    [CustomerKey]   int NOT NULL PRIMARY KEY Identity,
    [CustomerID]    nvarchar(5) NOT NULL,
    [CompanyName]    nvarchar(40) NOT NULL,
    [ContactName]    nvarchar(30) NOT NULL,
    [ContactTitle]    nvarchar(30) NOT NULL,
    [Address]        nvarchar(60) NOT NULL,
    [City]            nvarchar(15) NOT NULL,
    [Region]        nvarchar(15) NOT NULL,
    [PostalCode]    nvarchar(10) NOT NULL,
    [Country]        nvarchar(15) NOT NULL,
    [Phone]            nvarchar(24) NOT NULL,
    [Fax]            nvarchar(24) NOT NULL
    );

CREATE TABLE DimDates(
    [DateKey]        int NOT NULL PRIMARY KEY IDENTITY,
    [Date]            datetime NOT NULL,  
    [DateName]        nVarchar(50) NOT NULL,
    [Month]            int NOT NULL, 
    [MonthName]        nVarchar(50) NOT NULL,
    [Quarter]        int NOT NULL, 
    [QuarterName]    nVarchar(50) NOT NULL, 
    [Year]            int NOT NULL, 
    [YearName]        nVarchar(50) NOT NULL  
    );

CREATE TABLE DimOrders (
    [OrderKey]       int NOT NULL PRIMARY KEY IDENTITY, 
    [OrderID]        int NOT NULL,  
    [ShippedDate]    datetime NOT NULL, 
    [RequiredDate]   datetime NOT NULL, 
    [Freight]        money NOT NULL, 
    [ShipVia]        int NOT NULL, 
    [ShipName]       nvarchar(40) NOT NULL, 
    [ShipAddress]    nvarchar(60) NOT NULL, 
    [ShipCity]       nvarchar(15) NOT NULL, 
    [ShipRegion]     nvarchar(15) NOT NULL, 
    [ShipPostalCode] nvarchar(10) NOT NULL, 
    [ShipCountry]    nvarchar(15) NOT NULL, 
  );

CREATE TABLE DimProducts (
  [ProductKey]      int NOT NULL PRIMARY KEY IDENTITY, 
  [ProductID]       int NOT NULL, 
  [ProductName]     nvarchar(40) NOT NULL, 
  [SupplierID]      int NOT NULL, 
  [CategoryID]      int NOT NULL, 
  [QuantityPerUnit] nvarchar(20) NOT NULL, 
  [UnitPrice]       money NOT NULL, 
  [UnitsInStock]    smallint DEFAULT 0 NOT NULL, 
  [ReorderLevel]    smallint DEFAULT 0 NOT NULL, 
  [UnitsOnOrder]    smallint DEFAULT 0 NOT NULL, 
  [Discontinued]    bit NOT NULL, 
  );

--FactTable
CREATE TABLE FactSales(
  [CustomerKey] int NOT NULL, 
  [ProductKey]  int NOT NULL, 
  [OrderKey]    int NOT NULL, 
  [DateKey]     int NOT NULL, 
  [UnitPrice]   money NOT NULL, 
  [Quantity]    smallint DEFAULT 1 NOT NULL, 
  [Discount]    real DEFAULT 0 NOT NULL, 
 CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED ( [CustomerKey], [ProductKey], [OrderKey], [DateKey] )
)
GO

--FK
ALTER TABLE FactSales ADD CONSTRAINT DimCustomersFactSalesFK 
FOREIGN KEY (CustomerKey) REFERENCES DimCustomers (CustomerKey);

ALTER TABLE FactSales ADD CONSTRAINT DimDatesFactSales 
FOREIGN KEY (DateKey) REFERENCES DimDates (DateKey);

ALTER TABLE FactSales ADD CONSTRAINT DimOrdersFactSalesFK 
FOREIGN KEY (OrderKey) REFERENCES DimOrders (OrderKey);

ALTER TABLE FactSales ADD CONSTRAINT DimProductsFactSalesFK 
FOREIGN KEY (ProductKey) REFERENCES DimProducts (ProductKey);

