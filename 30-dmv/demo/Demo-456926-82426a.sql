--Динамические административные представления, относящиеся к операционной системе SQL Server

--Время старта сервера, количество ядер, ОЗУ(Мб)
select sqlserver_start_time, cpu_count, CAST(physical_memory_kb / 1024. AS int) as Mb from sys.dm_os_sys_info

--сведения о версии операционной системы
select * from sys.dm_os_host_info

--Место на диске где лежит БД
select database_id, f.file_id, f.name, volume_mount_point, total_bytes, available_bytes  
from sys.database_files AS f  
outer APPLY sys.dm_os_volume_stats(DB_ID('WideWorldImporters'), f.file_id)

--Место внутри файлов базы данных = текущая БД
SELECT name, size/128.0 FileSizeInMB,
size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 
   AS EmptySpaceInMB
FROM sys.database_files;

--Уровень изоляции сессий
SELECT session_id, 
CASE transaction_isolation_level
WHEN 0 THEN 'Unspecified'
WHEN 1 THEN 'Read Uncommitted'
WHEN 2 THEN 'Read Committed'
WHEN 3 THEN 'Repeatable'
WHEN 4 THEN 'Serializable'
WHEN 5 THEN 'Snapshot' END AS TRANSACTION_ISOLATION_LEVEL
FROM sys.dm_exec_sessions


--с использованием представлений метаданных - не используемые индексы(от старта)
select * from (
select DB_NAME(t.database_id) as [DBName]
, SCHEMA_NAME(obj.schema_id) as [SchemaName]
, OBJECT_NAME(t.object_id) as [ObjectName]
, obj.Type as [ObjectType]
, obj.Type_Desc as [ObjectTypeDesc]
, ind.name as [IndexName]
, ind.Type as IndexType
, ind.Type_Desc as IndexTypeDesc
, ind.Is_Unique as IndexIsUnique
, ind.is_primary_key as IndexIsPK
, ind.is_unique_constraint as IndexIsUniqueConstraint
, t.[Database_ID]
, t.[Object_ID]
, t.[Index_ID]
, t.Last_User_Seek
, t.Last_User_Scan
, t.Last_User_Lookup
, t.Last_System_Seek
, t.Last_System_Scan
, t.Last_System_Lookup
from sys.dm_db_index_usage_stats as t
inner join sys.objects as obj on t.[object_id]=obj.[object_id]
inner join sys.indexes as ind on t.[object_id]=ind.[object_id] and t.index_id=ind.index_id
where (last_user_seek is null or last_user_seek <dateadd(year,-1,getdate()))
--and (last_user_scan is null or last_user_scan <dateadd(year,-1,getdate()))
--and (last_user_lookup is null or last_user_lookup <dateadd(year,-1,getdate()))
--and (last_system_seek is null or last_system_seek <dateadd(year,-1,getdate()))
--and (last_system_scan is null or last_system_scan <dateadd(year,-1,getdate()))
--and (last_system_lookup is null or last_system_lookup <dateadd(year,-1,getdate()))
--and t.database_id>4 and t.[object_id]>0 --исключаются системные БД
) a
order by a.ObjectName

--Текущие запросы в БД
 select db_name(database_id),qt.text,* 
 from sys.dm_exec_requests qs
 CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
 where db_name(database_id) = 'WideWorldImporters'

 SELECT TOP 400
       [Average CPU used] = total_worker_time / qs.execution_count,
       [Total CPU used] = total_worker_time,
       [Execution count] = qs.execution_count,
       [Individual Query] = SUBSTRING(qt.text,qs.statement_start_offset/2, 
         (CASE
            WHEN qs.statement_end_offset = -1 THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
            ELSE qs.statement_end_offset
          END - qs.statement_start_offset)/2),
       [Parent Query] = qt.text,
       [DatabaseName] = DB_NAME(qt.dbid)
  FROM sys.dm_exec_query_stats qs
  CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
  --where (total_worker_time / qs.execution_count) > 1000000
  ORDER BY [Execution count] desc, [Average CPU used] DESC;
