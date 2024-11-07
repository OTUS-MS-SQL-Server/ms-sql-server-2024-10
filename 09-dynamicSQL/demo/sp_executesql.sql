

----sp_executesql
Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000),
	@param NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'
--SET @CustomerName = 'Tailspin Toys (Guin, AL)'' OR 1=1 --' --�� �������!!!

SET @command = 'SELECT top 20 CustomerName, CustomerId 
			FROM Sales.Customers WHERE CustomerName = @CustomerName'; 

SELECT @command;
SET @param = '@CustomerName NVARCHAR(50)'

EXEC sp_executesql @command        --�������
                  ,@param          --���� ����������
				  ,@CustomerName;  --����������



----------- � ��� � ORDER BY ���������� �� ����������
DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10;

SET @sort = 'CustomerId'

SET @query = 'SELECT top '+ CAST(@cnt AS VARCHAR(10))
	+' CustomerName, CustomerId FROM Sales.Customers ORDER BY '+@sort+';' --!!!

	select @query;
EXEC sp_executesql @query;

------------ � ����� ����� ���� ������� ��������

DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10;

SET @sort = 'CreditLimit DESC; DROP TABLE dbo.test'
--SET @sort = 'CreditLimit DESC; DROP TABLE if exists dbo.test' --���� ������ �� ������!!!

SET @query = 'SELECT top '+ CAST(@cnt AS VARCHAR(10))
	+' CustomerName, CustomerId FROM Sales.Customers ORDER BY '+@sort+';'

PRINT @query;
EXEC sp_executesql @query;
---------


--����� ����������
---� ������������ ������ ���������� 4 ����������, ��� �� ������� ������� ���������
declare @var1 int, @var2 varchar(100), @var3 varchar(100), @var4 int;
declare @mysql nvarchar(4000);
set @mysql = 'set @var1 = @var1 + @var4; set @var2 = ''CCCC''; set @var3 = @var3 + ''dddd''';
set @var1 = 0;
set @var2 = 'BBBB';
set @var3 = 'AAAA';
set @var4 = 10;

--����������� ������� ��������� ������ �������
select @var1, @var2, @var3;
exec sp_executesql @mysql, N'@var1 int, @var2 varchar(100), @var3 varchar(100), @var4 int', 
@var1, @var2, @var3, @var4;

--��� ������???
select @var1, @var2, @var3;

--� ���� ���������� �� ��� OUT , �� ��� �������� ������
exec sp_executesql @mysql, N'@var1 int out, @var2 varchar(100) out, @var3 varchar(100) out, @var4 int',   
@var1 out, @var2 out, @var3 out, @var4;

select @var1, @var2, @var3;
