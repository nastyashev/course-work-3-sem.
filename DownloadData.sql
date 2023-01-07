USE ZNO_RES_DB
GO

BULK INSERT [dbo].[Session]
FROM 'C:\Users\nasty\Documents\курсова 3 сем\ZNO_RES_data - Session.csv'
WITH
(
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR ='\n',
	FIRSTROW=2
)
GO


BULK INSERT [dbo].[Subject]
FROM 'C:\Users\nasty\Documents\курсова 3 сем\ZNO_RES_data - Subject.csv'
WITH
(
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR ='\n',
	FIRSTROW=2
)
GO


BULK INSERT [dbo].[Certificate]
FROM 'C:\Users\nasty\Documents\курсова 3 сем\ZNO_RES_data - Certificate.csv'
WITH
(
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR ='\n',
	FIRSTROW=2
)
GO


BULK INSERT [dbo].[TestingLocation]
FROM 'C:\Users\nasty\Documents\курсова 3 сем\ZNO_RES_data - TestingLocation.csv'
WITH
(
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR ='\n',
	FIRSTROW=2
)
GO


BULK INSERT [dbo].[ScoreScale]
FROM 'C:\Users\nasty\Documents\курсова 3 сем\ZNO_RES_data - ScoreScale.csv'
WITH
(
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR ='\n',
	FIRSTROW=2
)
GO


BULK INSERT [dbo].[InformationCard]
FROM 'C:\Users\nasty\Documents\курсова 3 сем\ZNO_RES_data - InformationCard.csv'
WITH
(
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR ='\n',
	FIRSTROW=2
)
GO


BULK INSERT [dbo].[Student]
FROM 'C:\Users\nasty\Documents\курсова 3 сем\ZNO_RES_data - Student.csv'
WITH
(
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR ='\n',
	FIRSTROW=2
)
GO


BULK INSERT [dbo].[ResultInfo]
FROM 'C:\Users\nasty\Documents\курсова 3 сем\ZNO_RES_data - ResultInfo.csv'
WITH
(
	CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR ='\n',
	FIRSTROW=2
)
GO


INSERT INTO [dbo].[Stats] (location_id, [registered_num])
SELECT [dbo].[TestingLocation].[location_id], COUNT([dbo].[Student].[student_id])
FROM [dbo].[TestingLocation] JOIN [dbo].[Student]
ON [dbo].[TestingLocation].location_id = [dbo].[Student].location_id
GROUP BY [dbo].[TestingLocation].[location_id];

UPDATE [dbo].[Stats]
SET [participated_num] = (SELECT COUNT([student_id]) FROM [dbo].[Student]
WHERE ([dbo].[Stats].location_id = [dbo].[Student].location_id) AND [dbo].[Student].participated = 1);

UPDATE [dbo].[Stats]
SET [average_score] = (SELECT AVG([result]) FROM
(SELECT [dbo].[Student].location_id, [dbo].[ResultInfo].result
FROM [dbo].[Student] JOIN [dbo].[ResultInfo]
ON [dbo].[Student].info_card_id = [dbo].[ResultInfo].info_card_id)
AS ResByLocation
WHERE ResByLocation.location_id = [dbo].[Stats].location_id);
