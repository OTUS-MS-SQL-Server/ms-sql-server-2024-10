USE [WideWorldImporters]

---- ���������� ����������
--������� 1
DECLARE @CustomerId INT,
		@CustId INT = 0,
		@InvoiceDate DATE;

--- �������������
set @CustId = 10
   --,@CustomerId = 10

--select @CustId = 10
--      ,@CustomerId = 10


set @CustomerId = (select max(CustomerID) from Sales.Customers);
select @CustId
      ,@CustomerId;


--������� 2
Declare @InvoiceId INT;
DECLARE @TransactionDate DATE;
DECLARE @CustomerName NVARCHAR(100);

SELECT 
	@InvoiceId = InvoiceID,
	@TransactionDate = TransactionDate
FROM Sales.CustomerTransactions
ORDER BY TransactionDate DESC;

select @InvoiceId
      ,@TransactionDate;

--���������� �� ����� ��������?
SELECT TOP 1
	@InvoiceId = InvoiceID,
	@TransactionDate = TransactionDate
FROM Sales.CustomerTransactions
ORDER BY TransactionDate DESC;

select @InvoiceId, @TransactionDate;

--��� ��� ��� ��������
DECLARE @Customes NVARCHAR(1000);
set @Customes='';
SELECT @Customes = @Customes + cast(c.CustomerID as nvarchar(10))+','
FROM Sales.CustomerTransactions c
ORDER BY TransactionDate DESC;

select @Customes

SELECT c.CustomerID
FROM Sales.CustomerTransactions c
ORDER BY TransactionDate DESC;