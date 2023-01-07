USE ZNO_RES_DB
GO


--���������� ���� ��� �� ���
DROP PROCEDURE IF EXISTS CountScore

CREATE PROC CountScore
AS
UPDATE [dbo].[ResultInfo]
SET 
[result] = [dbo].[ScoreScale].rating_score,
[sfe] = [dbo].[ScoreScale].[sfe]
FROM [dbo].[ScoreScale]
WHERE [dbo].[ResultInfo].test_score = [dbo].[ScoreScale].test_score AND [dbo].[ResultInfo].subject_id = [dbo].[ScoreScale].subject_id;

EXEC CountScore;


--������� ��� �� id
DROP FUNCTION IF EXISTS dbo.AvgScoreById

CREATE FUNCTION dbo.AvgScoreById(@id INT)
RETURNS DECIMAL(6,3)
AS
BEGIN
	DECLARE @avg_score int;
	SET @avg_score = (SELECT AVG(result)
	FROM [dbo].[ResultInfo] JOIN [dbo].[Student] 
	ON [dbo].[ResultInfo].info_card_id = [dbo].[Student].info_card_id
	WHERE [dbo].[Student].student_id = @id);
	RETURN @avg_score;
END;

SELECT dbo.AvgScoreById(3) AS average_score


--��������� ��������� �� ������� ��������
CREATE VIEW results AS
SELECT
[dbo].[Student].student_id, [dbo].[InformationCard].info_card_id, [dbo].[Subject].subject_name, [dbo].[ResultInfo].res_info_id, 
[dbo].[ResultInfo].test_score, [dbo].[Subject].max_test_score, [dbo].[ResultInfo].result, [dbo].[ResultInfo].sfe
FROM
[dbo].[Student] JOIN [dbo].[InformationCard] ON [dbo].[Student].info_card_id = [dbo].[InformationCard].info_card_id
JOIN [dbo].[ResultInfo] ON [dbo].[ResultInfo].info_card_id = [dbo].[InformationCard].info_card_id
JOIN [dbo].[Subject] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id

SELECT * FROM results
ORDER BY student_id


--��'�, �������, ��� ���
SELECT
[dbo].[Student].full_name, [dbo].[Subject].subject_name, [dbo].[ResultInfo].result
FROM
[dbo].[Student] JOIN [dbo].[ResultInfo] ON [dbo].[Student].info_card_id = [dbo].[ResultInfo].info_card_id
JOIN [dbo].[Subject] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
ORDER BY full_name


--��'�, ����� ���. ������, ��, �� ���������, ��������
SELECT
[dbo].[Student].full_name, [dbo].[Student].info_card_id, [dbo].[InformationCard].pin_code, 
[dbo].[InformationCard].year_of_receipt, [dbo].[Certificate].subjects
FROM
[dbo].[Student] JOIN [dbo].[InformationCard] ON [dbo].[Student].info_card_id = [dbo].[InformationCard].info_card_id
JOIN [dbo].[Certificate] ON [dbo].[InformationCard].certificate_id = [dbo].[Certificate].certificate_id


--������� ������������� �� ���, ��� ���� ������ �� ��������
SELECT
[dbo].[TestingLocation].region, SUM([dbo].[Stats].registered_num) AS registered, 
SUM([dbo].[Stats].participated_num) AS participated
FROM
[dbo].[TestingLocation] JOIN [dbo].[Stats] ON [dbo].[TestingLocation].location_id = [dbo].[Stats].location_id
GROUP BY region


--������� ��� �� ��������
SELECT
[dbo].[TestingLocation].region, AVG([dbo].[Stats].average_score) AS average_score
FROM
[dbo].[TestingLocation] JOIN [dbo].[Stats] ON [dbo].[TestingLocation].location_id = [dbo].[Stats].location_id
GROUP BY region


--������� ��� �� ���������
SELECT
[dbo].[Subject].subject_name, AVG([dbo].[ResultInfo].result) AS average_score
FROM
[dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
GROUP BY subject_name


--������� ����� � ������������ ����� �� ���������
SELECT
[dbo].[Subject].subject_name, COUNT([dbo].[ResultInfo].result) AS max_num
FROM
[dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
WHERE [dbo].[ResultInfo].result = 200
GROUP BY subject_name


--������� ����� � ����� ���
SELECT
[dbo].[ResultInfo].session_name, COUNT([dbo].[Student].student_id) AS stud_num
FROM [dbo].[ResultInfo] JOIN [dbo].[Student] ON [dbo].[ResultInfo].info_card_id = [dbo].[Student].info_card_id
GROUP BY session_name


--������� �����, �� ������ ��������
SELECT
[dbo].[Subject].subject_name, COUNT([dbo].[ResultInfo].subject_id) AS stud_num
FROM [dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
GROUP BY subject_name


--����� ���� ��� ����������� ��������
SELECT [dbo].[Subject].subject_name, [dbo].[ScoreScale].test_score, [dbo].[ScoreScale].rating_score, [dbo].[ScoreScale].sfe
FROM [dbo].[Subject] JOIN [dbo].[ScoreScale] ON [dbo].[Subject].subject_id = [dbo].[ScoreScale].subject_id
WHERE [dbo].[Subject].subject_id = 2


--������� ��������, �� ����� 200
SELECT COUNT(DISTINCT [student_id]) AS stud_num
FROM [dbo].[Student]
JOIN  [dbo].[ResultInfo] ON [dbo].[ResultInfo].info_card_id = [dbo].[Student].info_card_id
WHERE [dbo].[ResultInfo].result = 200


--����� ���, ��� ������� � 2022
SELECT full_name
FROM [dbo].[Student]
JOIN [dbo].[InformationCard] ON [dbo].[Student].info_card_id = [dbo].[InformationCard].info_card_id
WHERE [dbo].[InformationCard].year_of_receipt = 2022


--������� ����� �� �����
SELECT
[dbo].[InformationCard].year_of_receipt, COUNT([dbo].[Student].student_id) AS stud_num
FROM
[dbo].[InformationCard] JOIN [dbo].[Student] ON [dbo].[Student].info_card_id = [dbo].[InformationCard].info_card_id
GROUP BY year_of_receipt


--������ ���, ��� �� ���� ������ � ��� �� �������
SELECT [dbo].[Student].full_name, 
([dbo].[TestingLocation].region + ', ' + [dbo].[TestingLocation].district + ', ' + [dbo].[TestingLocation].settlement) AS region
FROM [dbo].[Student] JOIN [dbo].[TestingLocation] ON [dbo].[Student].location_id = [dbo].[TestingLocation].location_id
WHERE [dbo].[Student].participated = 0


--���������� �� ��� ����
SELECT [dbo].[Student].full_name, SUM([dbo].[ResultInfo].result) AS sum_result
FROM [dbo].[Student] JOIN [dbo].[ResultInfo] ON [dbo].[Student].info_card_id = [dbo].[ResultInfo].info_card_id
GROUP BY full_name
ORDER BY sum_result DESC


--���������� �� ���������� ����
SELECT [dbo].[Student].full_name, AVG([dbo].[ResultInfo].result) AS avg_result
FROM [dbo].[Student] JOIN [dbo].[ResultInfo] ON [dbo].[Student].info_card_id = [dbo].[ResultInfo].info_card_id
GROUP BY full_name
ORDER BY avg_result DESC


--������� ����� � ����� � ����� 200
SELECT COUNT(*) AS stud_num
FROM (
SELECT [student_id]
FROM [dbo].[Student]
JOIN  [dbo].[ResultInfo] ON [dbo].[ResultInfo].info_card_id = [dbo].[Student].info_card_id
WHERE [dbo].[ResultInfo].result = 200
GROUP BY [student_id]
HAVING COUNT(*) > 1) AS students


--������� ����� �� �������� ���� �� ��������
SELECT
[dbo].[Subject].subject_name, COUNT([dbo].[ResultInfo].subject_id) AS stud_num
FROM [dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
WHERE [dbo].[ResultInfo].result IS NOT NULL
GROUP BY subject_name


--������� ����� �� �������� >150 � ������� ���� �� ��������
SELECT
[dbo].[Subject].subject_name, COUNT([dbo].[ResultInfo].subject_id) AS stud_num
FROM [dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
WHERE [dbo].[ResultInfo].result >= 150 AND [dbo].[ResultInfo].session_name = '�������'
GROUP BY subject_name


--����� ��� ����� ����
DROP INDEX IF EXISTS [dbo].[ScoreScale].idx_subject_id

CREATE INDEX idx_subject_id
ON [dbo].[ScoreScale] ([subject_id])

/* Switch on statistics time */
SET STATISTICS TIME ON;

/*SQL statement*/
SELECT * FROM [dbo].[ScoreScale];

/* Switch off statistics time */
SET STATISTICS TIME OFF; 
GO


--������ �� ��������� �������� (������� ����������)
DROP TRIGGER IF EXISTS Student_insert

CREATE TRIGGER Student_insert
ON [dbo].[Student]
AFTER INSERT
AS
BEGIN
	UPDATE [dbo].[Stats]
	SET [dbo].[Stats].registered_num = [dbo].[Stats].registered_num + 1
	FROM [dbo].[Stats] JOIN [dbo].[Student]
	ON [dbo].[Student].location_id = [dbo].[Stats].location_id
END;

--������ �� ��������� �������� (������� ����������)
DROP TRIGGER IF EXISTS Student_delete

CREATE TRIGGER Student_delete
ON [dbo].[Student]
AFTER DELETE
AS
BEGIN
	UPDATE [dbo].[Stats]
	SET [dbo].[Stats].registered_num = [dbo].[Stats].registered_num - 1
	FROM [dbo].[Stats] JOIN [dbo].[Student]
	ON [dbo].[Student].location_id = [dbo].[Stats].location_id
END;


SELECT * FROM [dbo].[Stats] WHERE [location_id] = 1;
INSERT INTO [dbo].[Student] ([full_name], [location_id]) VALUES ('�������� �. �.', 1);
DELETE FROM [dbo].[Student] WHERE [full_name] = '�������� �. �.';
