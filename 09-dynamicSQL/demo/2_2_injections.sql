use WideWorldImporters

---- ��������
Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'' OR 1 = 1 --'

SET @command = 'SELECT top 20 CustomerName, CustomerId 
FROM Sales.Customers WHERE CustomerName = '''+@CustomerName+''''; 

SELECT @command;

--SELECT top 20 CustomerName, CustomerId   FROM Sales.Customers WHERE CustomerName = 'Tailspin Toys (Guin, AL)' OR 1 = 1 --'

EXECute (@command);



---����������� �������� ����
Declare @CustomerName NVARCHAR(50),
	@command NVARCHAR(4000),
	@param NVARCHAR(4000);

SET @CustomerName = 'Tailspin Toys (Guin, AL)'
--SET @CustomerName = 'Tailspin Toys (Guin, AL)'' OR 1 = 1 --'

SET @command = 'SELECT top 20 CustomerName, CustomerId 
			FROM Sales.Customers WHERE CustomerName = '+QUOTENAME(@CustomerName,''''); --���������� ����� QUOTENAME

SELECT @command;

EXEC (@command);
---------


---��������� � ����� = ������ ����
Declare @table NVARCHAR(50),
	@schema NVARCHAR(50),
	@command NVARCHAR(4000);

SET @schema = 'Sales'
SET @table = 'Orders'

SET @command = 'SELECT top 20 * FROM '+QUOTENAME(@schema)+'.'+QUOTENAME(@table); 

SELECT @command;

EXEC (@command);




------- ��� �������� - ��������� ���������
DECLARE @query NVARCHAR(4000),
		@sort NVARCHAR(100),
		@cnt INT = 10,
		@PersonId INT, 
		@Name NVARCHAR(200);

SET @Name = 'Amy Trefl'' UNION ALL 
SELECT null, loginname COLLATE Latin1_General_100_CI_AS, null FROM sys.syslogins; --'

SET @query = N'SELECT top '+CAST(@cnt AS NVARCHAR(50))+' PersonId, FullName, IsEmployee 
	FROM Application.People
	WHERE FullName = '''+@Name+'''';

PRINT @query;
EXEC (@query);
