--creating logins
CREATE LOGIN student WITH PASSWORD = '<password123>';
GO

CREATE LOGIN examiner WITH PASSWORD = '<password123>';
GO

USE ZNO_RES_DB
GO

--creating roles
CREATE ROLE student;

CREATE ROLE examiner;

--restrictions for roles
GRANT SELECT ON [dbo].[Certificate] TO student;
GRANT SELECT ON [dbo].[InformationCard] TO student;
GRANT SELECT ON [dbo].[ResultInfo] TO student;
GRANT SELECT ON [dbo].[Stats] TO student;
GRANT SELECT, INSERT ON [dbo].[Student] TO student;
GRANT INSERT ON [dbo].[TestingLocation] TO student;

GRANT SELECT ON [dbo].[Certificate] TO examiner;
GRANT SELECT ON [dbo].[InformationCard] TO examiner;
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[ResultInfo] TO examiner;
GRANT SELECT ON [dbo].[ScoreScale] TO examiner;
GRANT SELECT ON [dbo].[Session] TO examiner;
GRANT SELECT ON [dbo].[Stats] TO examiner;
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Student] TO examiner;
GRANT SELECT ON [dbo].[Subject] TO examiner;
GRANT SELECT ON [dbo].[TestingLocation] TO examiner;

--creating users
CREATE USER new_student FOR LOGIN student;
ALTER ROLE student ADD MEMBER new_student;

CREATE USER new_examiner FOR LOGIN examiner;
ALTER ROLE examiner ADD MEMBER new_examiner;