USE master
GO

IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'ZNO_RES_DB'
)
   DROP DATABASE ZNO_RES_DB
GO

CREATE DATABASE ZNO_RES_DB
GO

--creating tables
USE ZNO_RES_DB
GO


IF OBJECT_ID ('dbo.Student', 'U') IS NOT NULL  
   DROP TABLE Student;  
GO 
CREATE TABLE Student
(
	student_id INT IDENTITY(1,1) NOT NULL,
	full_name VARCHAR(50),
	info_card_id INT,
	participated BIT,
	location_id INT,
	CONSTRAINT PK_Student_student_id PRIMARY KEY (student_id)
);


IF OBJECT_ID ('dbo.InformationCard', 'U') IS NOT NULL  
   DROP TABLE InformationCard;  
GO 
CREATE TABLE InformationCard
(
	info_card_id INT IDENTITY(1,1) NOT NULL,
	pin_code INT NOT NULL,
	year_of_receipt INT NOT NULL,
	certificate_id INT NOT NULL,
	CONSTRAINT PK_InformationCard_info_card_id PRIMARY KEY (info_card_id)
);


IF OBJECT_ID ('dbo.ResultInfo', 'U') IS NOT NULL  
   DROP TABLE ResultInfo;  
GO 
CREATE TABLE ResultInfo
(
	res_info_id INT IDENTITY(1,1) NOT NULL,
	subject_id INT,
	test_score INT,
	result DECIMAL(4,1),
	sfe INT,
	session_name VARCHAR(50),
	info_card_id INT NOT NULL,
	CONSTRAINT PK_ResultInfo_res_info_id PRIMARY KEY (res_info_id)
);


IF OBJECT_ID ('dbo.Certificate', 'U') IS NOT NULL  
   DROP TABLE "Certificate";  
GO 
CREATE TABLE "Certificate"
(
	certificate_id INT IDENTITY(1,1) NOT NULL,
	subjects VARCHAR(255),
	CONSTRAINT PK_Certificate_certificate_id PRIMARY KEY (certificate_id)
);


IF OBJECT_ID ('dbo.Subject', 'U') IS NOT NULL  
   DROP TABLE "Subject";  
GO 
CREATE TABLE "Subject"
(
	subject_id INT IDENTITY(1,1) NOT NULL,
	subject_name VARCHAR(50),
	max_test_score INT,
	CONSTRAINT PK_Subject_subject_id PRIMARY KEY (subject_id)
);


IF OBJECT_ID ('dbo.ScoreScale', 'U') IS NOT NULL  
   DROP TABLE ScoreScale;  
GO 
CREATE TABLE ScoreScale
(
	score_scale_id INT IDENTITY(1,1) NOT NULL,
	subject_id INT NOT NULL,
	test_score INT,
	rating_score DECIMAL(4,1),
	sfe INT,
	CONSTRAINT PK_ScoreScale_score_scale_id PRIMARY KEY (score_scale_id)
);


IF OBJECT_ID ('dbo.Session', 'U') IS NOT NULL  
   DROP TABLE "Session";  
GO 
CREATE TABLE "Session"
(
	session_name VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Session_session_name PRIMARY KEY (session_name)
);


IF OBJECT_ID ('dbo.TestingLocation', 'U') IS NOT NULL  
   DROP TABLE TestingLocation;  
GO 
CREATE TABLE TestingLocation
(
	location_id INT IDENTITY(1,1) NOT NULL,
	region VARCHAR(50),
	district VARCHAR(50),
	settlement VARCHAR(50),
	CONSTRAINT PK_TestingLocation_location_id PRIMARY KEY (location_id)
);


IF OBJECT_ID ('dbo.Stats', 'U') IS NOT NULL  
   DROP TABLE "Stats";  
GO 
CREATE TABLE "Stats"
(
	stats_id INT IDENTITY(1,1) NOT NULL,
	location_id INT NOT NULL,
	registered_num INT,
	participated_num INT,
	average_score DECIMAL(6,3),
	CONSTRAINT PK_Stats_stats_id PRIMARY KEY (stats_id)
);


--creating constrains
ALTER TABLE Student
	ADD CONSTRAINT FK_Student_info_card_id FOREIGN KEY (info_card_id)
		REFERENCES InformationCard (info_card_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		CONSTRAINT FK_Student_location_id FOREIGN KEY (location_id)
		REFERENCES TestingLocation (location_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE;


ALTER TABLE InformationCard
	ADD CONSTRAINT FK_InformationCard_certificate_id FOREIGN KEY (certificate_id)
		REFERENCES "Certificate" (certificate_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE;


ALTER TABLE ResultInfo
	ADD CONSTRAINT FK_ResultInfo_subject_id FOREIGN KEY (subject_id)
		REFERENCES "Subject" (subject_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
		CONSTRAINT FK_ResultInfo_info_card_id FOREIGN KEY (info_card_id)
		REFERENCES InformationCard (info_card_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		CONSTRAINT FK_ResultInfo_session_name FOREIGN KEY (session_name)
		REFERENCES "Session" (session_name)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		CHECK (result >= 100 AND result <= 200),
		CHECK (sfe >= 1 AND sfe <= 12);


ALTER TABLE ScoreScale
	ADD CONSTRAINT FK_ScoreScale_subject_id FOREIGN KEY (subject_id)
		REFERENCES "Subject" (subject_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
		CHECK (rating_score >= 100 AND rating_score <= 200),
		CHECK (sfe >= 1 AND sfe <= 12);


ALTER TABLE "Stats"
	ADD CONSTRAINT FK_Stats_location_id FOREIGN KEY (location_id)
		REFERENCES TestingLocation (location_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE;