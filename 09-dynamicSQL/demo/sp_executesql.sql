

----sp_executesql
Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000),
	@param NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'
--SET @CustomerName = 'Tailspin Toys (Guin, AL)'' OR 1=1 --' --НЕ пройдет!!!

SET @command = 'SELECT top 20 CustomerName, CustomerId 
			FROM Sales.Customers WHERE CustomerName = @CustomerName'; 

SELECT @command;
SET @param = '@CustomerName NVARCHAR(50)'

EXEC sp_executesql @command        --команда
                  ,@param          --типы переменных
				  ,@CustomerName;  --переменные



----------- А вот с ORDER BY переменную не подставить
DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10;

SET @sort = 'CustomerId'

SET @query = 'SELECT top '+ CAST(@cnt AS VARCHAR(10))
	+' CustomerName, CustomerId FROM Sales.Customers ORDER BY '+@sort+';' --!!!

	select @query;
EXEC sp_executesql @query;

------------ И ТЕПРЬ МОГУТ ОПЯЬ сделать иньекции

DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10;

SET @sort = 'CreditLimit DESC; DROP TABLE dbo.test'
--SET @sort = 'CreditLimit DESC; DROP TABLE if exists dbo.test' --Даже ошибку не увидим!!!

SET @query = 'SELECT top '+ CAST(@cnt AS VARCHAR(10))
	+' CustomerName, CustomerId FROM Sales.Customers ORDER BY '+@sort+';'

PRINT @query;
EXEC sp_executesql @query;
---------


--Много переменных
---в динамический запрос передаются 4 переменные, три из которых являюся выходными
declare @var1 int, @var2 varchar(100), @var3 varchar(100), @var4 int;
declare @mysql nvarchar(4000);
set @mysql = 'set @var1 = @var1 + @var4; set @var2 = ''CCCC''; set @var3 = @var3 + ''dddd''';
set @var1 = 0;
set @var2 = 'BBBB';
set @var3 = 'AAAA';
set @var4 = 10;

--транслируем внешние процедуры внутрь запроса
select @var1, @var2, @var3;
exec sp_executesql @mysql, N'@var1 int, @var2 varchar(100), @var3 varchar(100), @var4 int', 
@var1, @var2, @var3, @var4;

--Что увидим???
select @var1, @var2, @var3;

--А если определить их как OUT , то они вернутся наружу
exec sp_executesql @mysql, N'@var1 int out, @var2 varchar(100) out, @var3 varchar(100) out, @var4 int',   
@var1 out, @var2 out, @var3 out, @var4;

select @var1, @var2, @var3;
