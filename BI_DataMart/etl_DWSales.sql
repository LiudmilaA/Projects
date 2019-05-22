USE DWNorthwind
GO

-- Drop Foreign Keys 
Alter Table [dbo].[FactSales] Drop Constraint [DimCustomersFactSalesFK] 
Alter Table [dbo].[FactSales] Drop Constraint [DimDatesFactSales]
Alter Table [dbo].[FactSales] Drop Constraint [DimOrdersFactSalesFK]
Alter Table [dbo].[FactSales] Drop Constraint [DimProductsFactSalesFK]

--Clear all tables data warehouse tables and reset their Identity Auto Number 
Truncate Table dbo.FactSales
Truncate Table dbo.DimCustomers
Truncate Table dbo.DimDates
Truncate Table dbo.DimOrders
Truncate Table dbo.DimProducts


--Create  values for DimDates
Declare @StartDate datetime = '01/01/1990'
Declare @EndDate datetime = '01/01/2003' 

Declare @DateInProcess datetime
Set @DateInProcess = @StartDate

While @DateInProcess <= @EndDate
 Begin

 Insert Into DimDates 
 ( [Date], [DateName], [Month], [MonthName], [Quarter], [QuarterName], [Year], [YearName] )
 Values ( 
  @DateInProcess 
  , DateName( weekday, @DateInProcess )    
  , Month( @DateInProcess )    
  , DateName( month, @DateInProcess ) 
  , DateName( quarter, @DateInProcess ) 
  , 'Q' + DateName( quarter, @DateInProcess ) + ' - ' + Cast( Year(@DateInProcess) as nVarchar(50) )  
  , Year( @DateInProcess )
  , Cast( Year(@DateInProcess ) as nVarchar(50) ) 
  )  
 
 Set @DateInProcess = DateAdd(d, 1, @DateInProcess)
 End

Set Identity_Insert [DWNorthwind].[dbo].[DimDates] On

Insert Into [DWNorthwind].[dbo].[DimDates] 
  ( [DateKey]
  , [Date]
  , [DateName]
  , [Month]
  , [MonthName]
  , [Quarter]
  , [QuarterName]
  , [Year], [YearName] )
  Select 
    [DateKey] = -1
  , [Date] =  Cast('01/01/1900' as nVarchar(50) )
  , [DateName] = Cast('Unknown Day' as nVarchar(50) )
  , [Month] = -1
  , [MonthName] = Cast('Unknown Month' as nVarchar(50) )
  , [Quarter] =  -1
  , [QuarterName] = Cast('Unknown Quarter' as nVarchar(50) )
  , [Year] = -1
  , [YearName] = Cast('Unknown Year' as nVarchar(50) )
  Union
  Select 
    [DateKey] = -2
  , [Date] = Cast('02/01/1900' as nVarchar(50) )
  , [DateName] = Cast('Corrupt Day' as nVarchar(50) )
  , [Month] = -2
  , [MonthName] = Cast('Corrupt Month' as nVarchar(50) )
  , [Quarter] =  -2
  , [QuarterName] = Cast('Corrupt Quarter' as nVarchar(50) )
  , [Year] = -2
  , [YearName] = Cast('Corrupt Year' as nVarchar(50) )
Go
  Set Identity_Insert [DWNorthwind].[dbo].[DimDates] Off
Go

--Create value for DimCustomers
insert into DimCustomers
Select 
  [CustomerID] =  Cast (CustomerID as nvarchar(5)),
  [CompanyName] = Cast (CompanyName as nvarchar(40)),
  [ContactName] = (case when ContactName is not null then ContactName
                        when ContactName is null then 'n/a'
                    end),
  [ContactTitle] = (case when ContactTitle is not null then ContactTitle
                         when ContactTitle is null then 'n/a'
                    end),
  [Address] =(case when Address is not null then Address
                   when Address is null then 'n/a'
              end),
  [City] = (case when City is not null then City
                 when City is null then 'n/a'
             end),
  [Region] = (case when Region is not null then Region
                   when Region is null then 'n/a'
               end),
  [PostalCode] = (case when PostalCode is not null then PostalCode
                       when PostalCode is null then 'n/a'
                   end),
  [Country] = (case when Country is not null then Country
                    when Country is null then 'n/a'
               end),
  [Phone] = (case when Phone is not null then Phone
                  when Phone is null then 'n/a'
              end),
  [Fax] = (case when Fax is not null then Fax
                when Fax is null then 'n/a'
           end)
From Northwind.dbo.Customers

--Create value for DimOrders
insert into DimOrders
Select
  [OrderID] = OrderID,
  [ShippedDate] = (case when ShippedDate is not null then ShippedDate
                        when ShippedDate is null then '01/01/1900'
                   end),
  [RequiredDate] = (case when RequiredDate is not null then RequiredDate
                         when RequiredDate is null then '01/01/1900'
                    end),
  [Freight] = (case when Freight is not null then Freight
                    when Freight is null then 'n/a'
                end),
  [ShipVia] = (case when ShipVia is not null then ShipVia
                    when ShipVia is null then 'n/a'
                end),
  [ShipName] = (case when ShipName is not null then ShipName
                     when ShipName is null then 'n/a'
                end),
  [ShipAddress] = (case when ShipAddress is not null then ShipAddress
                        when ShipAddress is null then 'n/a'
                   end),
  [ShipCity] = (case when ShipCity is not null then ShipCity
                     when ShipCity is null then 'n/a'
                end),
  [ShipRegion] = (case when ShipRegion is not null then ShipRegion
                       when ShipRegion is null then 'n/a'
                  end),
  [ShipPostalCode] = (case when ShipPostalCode is not null then ShipPostalCode
                           when ShipPostalCode is null then 'n/a'
                      end),
  [ShipCountry] = (case when ShipCountry is not null then ShipCountry
                        when ShipCountry is null then 'n/a'
                    end)
From Northwind.dbo.Orders;

--Create value for DimProducts
insert into DimProducts
Select
  [ProductID] = ProductId,
  [ProductName] = ProductName,
  [SupplierID] = (case when SupplierID is not null then SupplierID
                       when SupplierID is null then 0
                  end),
  [CategoryID] = (case when CategoryID is not null then CategoryID
                       when CategoryID is null then 0
                  end),
  [QuantityPerUnit] = (case when QuantityPerUnit is not null then QuantityPerUnit
                            when QuantityPerUnit is null then 'n/a'
                        end),
  [UnitPrice] = (case when UnitPrice is not null then UnitPrice
                      when UnitPrice is null then 0
                  end),
  [UnitsInStock] = (case when UnitsInStock is not null then UnitsInStock
                         when UnitsInStock is null then 0
                     end),
  [ReorderLevel] = (case when ReorderLevel is not null then ReorderLevel
                         when ReorderLevel is null then 0
                     end),
  [UnitsOnOrder] = (case when UnitsOnOrder is not null then UnitsOnOrder
                         when UnitsOnOrder is null then 0
                     end),
  [Discontinued] = (case when Discontinued is not null then Discontinued
                         when Discontinued is null then 0
                     end)
From Northwind.dbo.Products;

--Create values for FactSales
INSERT INTO FactSales
SELECT
  [CustomerKey] = DimCustomers.CustomerKey,
  [ProductKey] = DimProducts.ProductKey,
  [OrderKey] = DimOrders.OrderKey,
  [DateKey] = DimDates.DateKey,
  [UnitPrice] = cast(Northwind.dbo.OrderDetails.UnitPrice as money),
  [Quantity] = cast (Northwind.dbo.OrderDetails.Quantity as smallint),
  [Discount] = cast (Northwind.dbo.OrderDetails.Discount as real)
FROM Northwind.dbo.OrderDetails
   JOIN DWNorthwind.dbo.DimProducts
     ON Northwind.dbo.OrderDetails.ProductID = DWNorthwind.dbo.DimProducts.ProductID
   JOIN DWNorthwind.dbo.DimOrders
     ON Northwind.dbo.OrderDetails.OrderID = DWNorthwind.dbo.DimOrders.OrderID
   JOIN NorthWind.dbo.Orders
     ON Northwind.dbo.OrderDetails.OrderID = Northwind.dbo.Orders.OrderID
   JOIN DWNorthwind.dbo.DimCustomers
     ON Northwind.dbo.Orders.CustomerID = DWNorthwind.dbo.DimCustomers.CustomerID
   JOIN DWNorthwind.dbo.DimDates
     ON Northwind.dbo.Orders.OrderDate = DWNorthwind.dbo.DimDates.Date;

--FK
ALTER TABLE FactSales ADD CONSTRAINT DimCustomersFactSalesFK 
FOREIGN KEY (CustomerKey) REFERENCES DimCustomers (CustomerKey);

ALTER TABLE FactSales ADD CONSTRAINT DimDatesFactSales 
FOREIGN KEY (DateKey) REFERENCES DimDates (DateKey);

ALTER TABLE FactSales ADD CONSTRAINT DimOrdersFactSalesFK 
FOREIGN KEY (OrderKey) REFERENCES DimOrders (OrderKey);

ALTER TABLE FactSales ADD CONSTRAINT DimProductsFactSalesFK 
FOREIGN KEY (ProductKey) REFERENCES DimProducts (ProductKey);

--Backup
BACKUP DATABASE [DWNorthwind] 
TO  DISK = 
N'C:\temp\backups\DWNorthwind.bak'
GO


