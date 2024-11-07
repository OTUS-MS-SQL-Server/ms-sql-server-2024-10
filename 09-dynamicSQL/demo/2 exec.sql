USE [WideWorldImporters]

EXEC ('SELECT 1 AS ValueDynamic');

EXEC ('SELECT CustomerName, CustomerId FROM Sales.Customers WHERE CustomerID = 1');
-------
---передача значения NULL (безошибочный результат?)
declare @i int;
declare @sql varchar(100) = 'select ' + str(@i + 1); 
select @sql;
execute( @sql );


--------Передача пустого списка
Declare @list varchar(100) = '';
--if @list = '' set @list = 'null'; --Защита от дурака
Declare @sql varchar(1000) = 
			'select TOP 10 * from Sales.Customers where CustomerID in ('+@list+') ';
select @sql;
Execute( @sql );


--------
-- передача параметров через временную таблицу
create table #params ( v1 int, v2 datetime, v3 nvarchar(100) );

insert #params values ( 1, getdate(), 'String ''1'' ');
declare @sql varchar(1000) = '
  declare @v1 int, @v2 datetime, @v3 nvarchar(100);
  select @v1 = v1 , @v2 = v2, @v3 = v3 from #params;
  select @v1, @v2, @v3;
'
execute(@sql);
drop table #params;

--В обратную сторону НЕ работает !!!
declare @sql varchar(1000) = 'create table #params ( v1 int, v2 datetime, v3 nvarchar(100) ); select * from #params;'
execute(@sql);


-------
--Создание последовательности(например для скозной нумерации объектов) с указанного значения
declare @id int, @str nvarchar(500);
select @id = max(CustomerID) from Sales.Customers;
select @id;

set @str = 'CREATE SEQUENCE cust_seq AS int START WITH ' + CAST(@id as varchar(10)) + ';';
select @str;
exec (@str);



-------
--- Динамический PIVOT
Use AdventureWorks2017;

SELECT SalesYear, 
       ISNULL([1], 0) AS Jan, 
       ISNULL([2], 0) AS Feb, 
       ISNULL([3], 0) AS Mar, 
       ISNULL([4], 0) AS Apr, 
       ISNULL([5], 0) AS May, 
       ISNULL([6], 0) AS Jun, 
       ISNULL([7], 0) AS Jul, 
       ISNULL([8], 0) AS Aug, 
       ISNULL([9], 0) AS Sep, 
       ISNULL([10], 0) AS Oct, 
       ISNULL([11], 0) AS Nov, 
       ISNULL([12], 0) AS Dec, 
       (ISNULL([1], 0) + ISNULL([2], 0) + ISNULL([3], 0) + ISNULL([4], 0) + ISNULL([4], 0) + ISNULL([5], 0) + ISNULL([6], 0) + ISNULL([7], 0) + ISNULL([8], 0) + ISNULL([9], 0) + ISNULL([10], 0) + ISNULL([11], 0) + ISNULL([12], 0)) SalesYTD
FROM
(   SELECT YEAR(SOH.OrderDate) AS SalesYear, 
           DATEPART(MONTH, SOH.OrderDate) Months,
          SOH.SubTotal AS TotalSales
    FROM sales.SalesOrderHeader SOH
         JOIN sales.SalesOrderDetail SOD ON SOH.SalesOrderId = SOD.SalesOrderId
 ) AS Data 
 PIVOT(SUM(TotalSales) 
 FOR Months IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS pvt 
   order by SalesYear;


------
DECLARE @dml AS NVARCHAR(MAX)
DECLARE @ColumnName AS NVARCHAR(MAX)
 
-- формируем список месяцев
SELECT @ColumnName = ISNULL(@ColumnName + ',','') 
                   + QUOTENAME(Months)--заключаем в квадратные скобки
FROM (SELECT DISTINCT  DATEPART(MONTH, SOH.OrderDate) Months
      FROM sales.SalesOrderHeader SOH
      JOIN sales.SalesOrderDetail SOD ON SOH.SalesOrderId = SOD.SalesOrderId
      GROUP BY YEAR(SOH.OrderDate),
			   DATEPART(MONTH, SOH.OrderDate)) AS Months

SELECT @ColumnName as ColumnName 

SET @dml = 
  N'SELECT SalesYear, ' +@ColumnName + ' FROM
  (
  SELECT YEAR(SOH.OrderDate) AS SalesYear, 
           DATEPART(MONTH, SOH.OrderDate) Months,
           SUM(SOH.SubTotal) AS TotalSales
   FROM sales.SalesOrderHeader SOH
         JOIN sales.SalesOrderDetail SOD ON SOH.SalesOrderId = SOD.SalesOrderId
    GROUP BY YEAR(SOH.OrderDate),
    DATEPART(MONTH, SOH.OrderDate)) AS T
    PIVOT(SUM(TotalSales) 
           FOR Months IN (' + @ColumnName + ')) AS PVTTable'


EXEC sp_executesql @dml



--------------
-- ЭКРАНИРОВАНИЕ кавычек !!!
USE [WideWorldImporters]

Declare @CustomerName NVARCHAR(50)
	   ,@command NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'

SET @command = 'SELECT top 20 CustomerName, CustomerId 
				FROM Sales.Customers WHERE CustomerName = ''' + @CustomerName + ''''; -- ЭКРАНИРОВАНИЕ кавычек !!!

SELECT @command;

EXEC (@command);
