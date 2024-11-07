USE WideWorldImporters
GO

-- ===================
-- NULL
-- ===================

-- Проверим, что работает
select dbo.AddNullError(1, 2)
go

-- не работает с NULL
select dbo.AddNullError(null, 2)
go

-- int? (nullable) - работает, но лучше так не делать
-- null внутри функции считается за ноль
select dbo.AddNullable(null, 2)
go

-- работает с NULL (NULL никак не обрабатываем)
select dbo.AddNullGood(null, 2)
select dbo.AddNullGood(1, null)
select dbo.AddNullGood(null, null)
go

select dbo.AddNullGood(200000000,2000000000) 
go

-- SqlInt32 - работает с NULL (NULL считаем за 0) 
select dbo.AddNullGoodZero(null, 2)
select dbo.AddNullGoodZero(1, null)
select dbo.AddNullGoodZero(null, null)
go

-- возвращаем NULL
select dbo.NullIfZero(2)
select dbo.NullIfZero(0)
go

-- return null работает, но так лучше не делать
select dbo.NullBad()
go

