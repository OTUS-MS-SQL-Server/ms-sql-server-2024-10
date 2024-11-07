
SELECT *
FROM Application.CitiesCopy
WHERE CityId = 15;

SELECT *
FROM Application.CitiesCopy
WHERE CityId = 299;

SELECT *
FROM Application.CitiesCopy
WHERE CityId = 45000;

SELECT *
FROM Application.CitiesCopy
WHERE CityId = CONVERT(INT,10);

SELECT *
FROM Application.CitiesCopy
WHERE CityId = CONVERT(INT,3100);

SELECT TOP 10 *
FROM Application.CitiesCopy
WHERE CityId > 35000;

CREATE INDEX IX_APCC_CityName ON Application.CitiesCopy (CityName);

SELECT * 
FROM Application.CitiesCopy
WHERE CityName = 'Jeffersonville';
GO
SELECT * 
FROM Application.CitiesCopy
WHERE CityName = 'Jeff';
GO
SELECT * 
FROM Application.CitiesCopy
WHERE CityName like 'Jeff%';

DECLARE @cityName NVARCHAR(50) = 'Jeff%';
SELECT * 
FROM Application.CitiesCopy
WHERE CityName like @cityName;
GO
DECLARE @cityName NVARCHAR(50) = 'Jeffersonville';
SELECT * 
FROM Application.CitiesCopy
WHERE CityName like @cityName;

DECLARE @execstr NVARCHAR(4000);
SET @execstr = 'SELECT *
FROM Application.CitiesCopy
WHERE CityId = @CityId;'
EXEC sp_executesql @execstr, N'@CityId INT', 500;	
GO
DECLARE @execstr NVARCHAR(4000);
SET @execstr = 'SELECT *
FROM Application.CitiesCopy
WHERE CityId = @CityId;'

EXEC sp_executesql @execstr, N'@CityId INT', 1200;
GO
DECLARE @execstr NVARCHAR(4000);
SET @execstr = 'SELECT *
FROM Application.CitiesCopy
WHERE CityId = @CityId;'

EXEC sp_executesql @execstr, N'@CityId INT', 35000;
GO
--чудесатые планы
SELECT * 
FROM Application.CitiesCopy
WHERE CityName like 'Jeff%';

SET statistics io, time on;

SELECT * 
FROM Application.CitiesCopy
WHERE CityName like '%e%';

SELECT * 
FROM Application.CitiesCopy
WHERE CityName like 'Jeffersonville';

DECLARE @execstr NVARCHAR(4000);
SET @execstr = 'SELECT *
FROM Application.CitiesCopy
WHERE CityName like @CityName;'

EXEC sp_executesql @execstr, N'@CityName NVARCHAR(50)', N'Jeffersonville';
GO

DECLARE @execstr NVARCHAR(4000);
SET @execstr = 'SELECT *
FROM Application.CitiesCopy
WHERE CityName like @CityName;'

EXEC sp_executesql @execstr, N'@CityName NVARCHAR(50)', N'Jeff';
GO
DECLARE @execstr NVARCHAR(4000);
SET @execstr = 'SELECT *
FROM Application.CitiesCopy
WHERE CityName like @CityName;'

EXEC sp_executesql @execstr, N'@CityName NVARCHAR(50)', N'%e%';
GO
SELECT *
FROM Application.CitiesCopy
WHERE CityName like '%E%';