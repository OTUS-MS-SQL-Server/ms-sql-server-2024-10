use WideWorldImporters
-- Databases - Programmability - Types - System Data Types

--------------------
--Точные числа: Сортировка + Арифметика? Фиксированные размеры 
--------------------
--bit  = boolean {0,1} - 1б, но общежитие для 8 колонок типа bit
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'bit' --People

--сравнение 
select * from Application.People where IsSalesperson > 0

--арифметики нет
select sum(IsSalesperson) from Application.People

--------------------
--tinyint без отрицательных чисел -- 1 байт -- 0..255 - хранение статусов

--выход за пределы типа 0..255 - ошибка
declare @a tinyint = 3, @b tinyint = 10
select @a - @b + @b - @a

--сколько будет?
select 1 / 2 --⬇




----
-- Неявное (скрытое) преобразование типов
-- остаемся в пределах типа => возможна потеря точности
-- https://learn.microsoft.com/ru-ru/sql/t-sql/data-types/data-type-conversion-database-engine?view=sql-server-ver16

--явное преобразование целое / на numeric 
select 1 / cast(2 as numeric(15, 2)) as [явное]
	 , 1 / convert(numeric(15, 2), 2) as [тоже явное] 	

select  1 / 2.


--что получим?
select 1 + '2', '1' + 2, '1' + '2' --⬇





--приоритет (операции над 2мя типами)
--char -> varchar -> nvarchar -> int -> decimal -> time -> date -> datetime2

-------------------
drop table if exists #t
go

--невное преобразование - не используется индекс
create table #t ( --клиенты
    id int identity primary key
    , name varchar(50) null
    , inn char(12) null unique --индекс
    );
go 
insert #t
values ('customer1','12345678901'),('customer2','112233445566'),('customer3','000123456789');
go
--Ctrl + M
select inn from #t where inn = 112233445566 --index scan
select inn from #t where inn = '112233445566' --используем индекс для поиска

--------------------
--int (4б) & bigint (8б)- часто как id - pk 
--см. диапазон значений
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'int'
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'bigint'

--bigint
select * from Warehouse.ColdRoomTemperatures --in-memory

--id -> int & bigint - суррогатный ключ => автоинкремент identity
--identity + частый del / ins => можем выйти за пределы типа 
--	(табл маленькая, id растет при каждой вставке)

drop table if exists #t 
go
create table #t (
	id int identity primary key
	, Status tinyint
)
insert #t (Status) values (100), (120), (90)
select * from #t

delete from #t --продолжение нумерации => большая таблица, частые ins/del => bigint
insert #t (Status) values (100), (120), (90)
select * from #t

--------------------
--точные числа с дробной частью
-- smallmoney / money -- редко нужен = numeric(10,4) / numeric(19,4)
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'money'
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'decimal'

-- numeric = decimal
-- numeric(5, 3) 
-- 5 - всего символов (зпт не учитывается)
-- 3 - после зпт
--синтаксическая ошибка точность > кол-во цифр в числе 
select cast(123.45 as numeric(5, 6))


select cast(2.5 as numeric)
--default numeric = numeric(18.0) 

select SQL_VARIANT_PROPERTY(cast(2.5 as numeric),'BaseType') AS 'Base Type'
	, SQL_VARIANT_PROPERTY(cast(2.5 as numeric),'Precision') AS 'Precision'
	, SQL_VARIANT_PROPERTY(cast(2.5 as numeric),'Scale') AS 'Scale'

--------------------
-- Приблизительные числа (с плавающей точкой)
-- Фиксированные размеры - REAL (4б) & FLOAT (8б), проблемы с точностью
-- короткая запись
select 1.79E308 --1.79 * 10**308 = 17900...00 

--float - короткая запись
select 2E6 as [2E6], 1E2 as [1E2]

-- особенности
-- не использовать для хранения точных чисел! особенно денег
-- сложно сравнивать
-- неточное округление

--сколько будет?
select cast(10000 as real) + cast(0.001 as real) --10 000,001



--ограниченная точность https://habr.com/ru/articles/337260/
--число с плавающей точкой: (-1)**S x 2**E x 1.М (М - мантисса)

--real - 4б = 4 * 8 бит = 24 бита
--real	 S	EEEEEEEE	MMMMMMMM MMMMMMMM MMMMMMM (23 байта под мантису)

--real - 23 байта под мантису гарантированная точность - 7 знаков
select cast(1234567 as real) as [1234567], cast(12345678 as real) as [12345678]


--сравнение
declare @f1 float = 0.1, @f2 float = 0.2
select @f1 + @f2, iif(@f1 + @f2 = 0.3, '=', '<>')

--еще сравнение: цикл от 0 до 1, приращение 0.1
declare @f float = 0.0
while @f <> 1
begin
	print @f
	set @f = @f + 0.1
end 



--------------------
--Дата и время --> Types
--------------------
select Sysdatetime() as [datetime2]
	, cast(Sysdatetime() as datetime2(0)) as [datetime2(0)]
	, cast(Sysdatetime() as datetime) as [datetime]
	, cast(Sysdatetime() as smalldatetime) as [smalldatetime]
	, cast(Sysdatetime() as date) as [date]
	, cast(Sysdatetime() as time) as [time]
	, cast(Sysdatetime() as time(0)) as [time(0)]
	, cast(Sysdatetimeoffset() as datetimeoffset) as [datetimeoffset]

select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'datetime2'
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'datetime'


--datetime - округляет до 1/300 сек       [1 янв 1753 - 31 дек 9999] [0 - 23:59:59.997]
select cast('17520101' as datetime)
--datetime2 - до 7 знаков после зпт в сек [1 янв 0000 - 31 дек 9999] [0 - 23:59:59.9999999]
select cast('17520101' as datetime2)
--
drop table if exists #t1 
drop table if exists #t2
go
create table #t1 (dt datetime2)
create table #t2 (dt datetime)
go

declare @dt1 datetime2 = '20231231'
	, @dt2 datetime2 = '20231231 23:59:59.9999999' --последняя дата в 2023 году
	, @dt3 datetime2 = '20240101'

insert #t1 values('20231231'), ('20231231 23:59:59.9999999'), ('20240101')
insert #t2 select * from #t1

select * from #t1

--запрос за декабрь
select * from #t1 where dt between '20231201' and '20231231 23:59:59.9999999'

--сколько строк в #t2? 
--select * from #t2 where dt between '20231201' and '20231231 23:59:59.9999999'



select * from #t2 where dt between '20231201' and '20231231 23:59:59.999'
select cast('20231231 23:59:59.999' as datetime)

select * from #t2 where dt between '20231201' and '20231231 23:59:59.997'

select * from #t1
select * from #t2 --округление







--------------------
--Строки
-- char/varchar - 1 символ = 1 байт => ограниченное кол-во символов (255 = 2**8 - 1)
-- Nchar/Nvarchar - юникод - 1 символ = 2 байта (65535 = 2**16 - 1) => хватит для всех языков мира
-- text/ntext - deprecated => varchar(max)/Nvarchar(max)
--------------------
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE in ('varchar', 'char')
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE in ('nvarchar', 'nchar')

--как задать и длина
select 'F' as [non-unicode], N'F' as [unicode]
select datalength('F') as [non-unicode], datalength(N'F') as [unicode]


drop table if exists t
go
create table t (
	[char(10)] char(10)
	, [varchar(10)] varchar(10) 
	, [nchar(10)] nchar(10)
	, [nvarchar(10)] nvarchar(10)
)

insert t 
values(N'OTUS фыва', N'OTUS фыва', N'OTUS фыва', N'OTUS фыва')

select * from t

declare @s nvarchar(10) = N'фыва' --без N - строка не в юникоде
select @s

--char - 1 байт нет русских символов (т.к. кодовая страница БД не русская)
select char(rn) as s, rn as code 
from (
	select row_number() over(order by 1/0) as rn from string_split(space(255), ' ')
) t 


SELECT DATABASEPROPERTYEX(db_name() , 'collation')
SELECT DATABASEPROPERTYEX('tempdb' , 'collation')


drop table if exists t

--collate - сравнивать
--!!! на уровне сервера, БД, колонки
--CI - чувствительность к регистру, AS - чувствительность к умлаут Mädchen = Madchen? ёжик = ежик
select * from sys.fn_helpcollations() where name = DATABASEPROPERTYEX(db_name() , 'collation')


select * from sys.fn_helpcollations() where name like 'Cyr%'

-- сравнение
select case when N'ёжик' = N'ежик' then '=' else '<>' end, DATABASEPROPERTYEX(db_name() , 'collation')
select case when N'ёжик' collate Latin1_General_100_CI_AI = N'ежик' then '=' else '<>' end


--SQL Не знает как сравнивать
select case 
	when N'ежик' collate Latin1_General_100_CI_AI = N'ежик' collate Latin1_General_100_CI_AS 
		then '=' 
		else '<>' 
		end

---
--макс размер строки - данные д.поместиться на страницу
drop table if exists #t
go
create table #t ( --4 + 100 + фикс. длина 8000 > 8060 => не поместились на страницу
	id int
	, name char(100)
	, descr char(8000)
	)

create table #t ( ----4 + 100 + переменная длина 8000 > 8060 все ок т.к. переменная длина
	id int
	, name varchar(100)
	, descr varchar(8000)
	)
insert #t values(1, replicate('a', 100), replicate('a', 8000))
select  * from #t

drop table if exists #t
go
create table #t (
	id int
	, name nvarchar(10)
	, descr Nvarchar(4000) --почему?
	)


-- > 8000 байт -> тип varchаr(max) до 2 ГБ
drop table if exists #t
go
create table #t (
	id int
	, name nvarchar(100)
	, descr nvarchar(max) --нюансы!!! не жмется, нет индекса, под хранение выделяются доп страницы LOB
	, descr1 varbinary(1000)
	)

insert #t values(1, N'test', null, compress(replicate(N'ф', 8000)))
select CAST(decompress(descr1) as nvarchar(max) ) from #t


--------------------
--Binaries
--------------------
-- binary(max)/varbinary(max) - аналогично строкам varchar(max) - до 2 ГБ
select * from INFORMATION_SCHEMA.COLUMNS where DATA_TYPE in ('varbinary', 'binary')
select HashedPassword, Photo from Application.People

--------------------
-- rowversion = timestamp = binary(8) с дополнительными возможностями
-- отслеживание изменений в строке
--------------------
drop table if exists #t
go
create table #t (a int, b rowversion)
insert #t(a) values (10), (20), (30)
select *, cast(b as int) from #t


--изменение при апдейте
update #t set a = 15 where a = 10
select *, cast(b as int) from #t

delete from #t where a = 20 --не влияет на rowversion
select *, cast(b as int) from #t
--alter table #t add isDeleted bit
--update #t set isDeleted = 1 where a = 20

--------------------
-- uniqueidentifier - 16б, 36 символов
-- глобально уникальны
-- часто генерятся в приложении
-- newid() vs newsequentialid() 
-- primary keys?
--------------------

select newid() --непредсказуемы (нет постоянного увеличения)
go 3


select * from AdventureWorks.INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'uniqueidentifier'
-- uniqueidentifier default newid() - не используется как clustered index
--обычно:
--	clustered index = id int
--	unique nonclustered index = GUID (нет постоянного роста)
--	или newsequentialid()
drop table if exists #t
go
create table #t (
	id int identity
	, gu uniqueidentifier default newid()
	, gu2 uniqueidentifier default newsequentialid()
	)
go
insert #t(gu, gu2) default values
go 3
select * from #t order by gu
select * from #t order by gu2
--select newsequentialid() --error


--------------------
--Хитрые типы
--------------------
-- geography, geometry
-- hierarchyid
-- sql_variant

--geography
--карта США
select * from Application.StateProvinces

--geometry
DECLARE @point1 GEOMETRY, @point2 GEOMETRY

-- Initialize the geometric points
SET @point1 = geometry::STGeomFromText('POINT( 0  0)', 0)
SET @point2 = geometry::STGeomFromText('POINT(10 10)', 0)

-- Calculate the distance - гипотенуза треугольника 10 x 10 = sqrt(10**2 + 10**2)
SELECT @point1.STDistance(@point2), sqrt(100 + 100)

-------------------
--hierarchyid - хранение иерархии в двоичном виде
-- не укладывается в реляционную теорию (fk не имеет смысла) => самостоятельно отслеживаем согласованность данных
select * from AdventureWorks.INFORMATION_SCHEMA.COLUMNS where DATA_TYPE = 'hierarchyid'
select OrganizationNode.ToString(), OrganizationNode, * from AdventureWorks.HumanResources.Employee

drop table if exists #t
go
create table #t (VersionNo varchar(10))
go
insert #t(VersionNo) values ('1.3'), ('1.2.3.1'), ('1.16.8.0.1'), ('1.4.7.2'), ('1.7.1'), ('1.10.3.1')
select * from #t order by VersionNo
--как отсортировать?



--hierarchyid
select VersionNo from #t 
order by cast('/' + replace(VersionNo , '.', '/') + '/' as hierarchyid)
