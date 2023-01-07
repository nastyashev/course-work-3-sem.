USE ZNO_RES_DB
GO


--розрахунок балів ЗНО та ДПА
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


--середній бал за id
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


--загальний результат по кожному учаснику
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


--ім'я, предмет, бал ЗНО
SELECT
[dbo].[Student].full_name, [dbo].[Subject].subject_name, [dbo].[ResultInfo].result
FROM
[dbo].[Student] JOIN [dbo].[ResultInfo] ON [dbo].[Student].info_card_id = [dbo].[ResultInfo].info_card_id
JOIN [dbo].[Subject] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
ORDER BY full_name


--ім'я, номер інф. картки, пін, рік отримання, предмети
SELECT
[dbo].[Student].full_name, [dbo].[Student].info_card_id, [dbo].[InformationCard].pin_code, 
[dbo].[InformationCard].year_of_receipt, [dbo].[Certificate].subjects
FROM
[dbo].[Student] JOIN [dbo].[InformationCard] ON [dbo].[Student].info_card_id = [dbo].[InformationCard].info_card_id
JOIN [dbo].[Certificate] ON [dbo].[InformationCard].certificate_id = [dbo].[Certificate].certificate_id


--кількість зареєстрованих та тих, хто взяв участь за регіонами
SELECT
[dbo].[TestingLocation].region, SUM([dbo].[Stats].registered_num) AS registered, 
SUM([dbo].[Stats].participated_num) AS participated
FROM
[dbo].[TestingLocation] JOIN [dbo].[Stats] ON [dbo].[TestingLocation].location_id = [dbo].[Stats].location_id
GROUP BY region


--середній бал за регіонами
SELECT
[dbo].[TestingLocation].region, AVG([dbo].[Stats].average_score) AS average_score
FROM
[dbo].[TestingLocation] JOIN [dbo].[Stats] ON [dbo].[TestingLocation].location_id = [dbo].[Stats].location_id
GROUP BY region


--середній бал по предметах
SELECT
[dbo].[Subject].subject_name, AVG([dbo].[ResultInfo].result) AS average_score
FROM
[dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
GROUP BY subject_name


--кількість людей з максимальним балом по предметах
SELECT
[dbo].[Subject].subject_name, COUNT([dbo].[ResultInfo].result) AS max_num
FROM
[dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
WHERE [dbo].[ResultInfo].result = 200
GROUP BY subject_name


--кількість людей в кожній сесії
SELECT
[dbo].[ResultInfo].session_name, COUNT([dbo].[Student].student_id) AS stud_num
FROM [dbo].[ResultInfo] JOIN [dbo].[Student] ON [dbo].[ResultInfo].info_card_id = [dbo].[Student].info_card_id
GROUP BY session_name


--кількість людей, які обрали предмети
SELECT
[dbo].[Subject].subject_name, COUNT([dbo].[ResultInfo].subject_id) AS stud_num
FROM [dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
GROUP BY subject_name


--шкала балів для конкретного предмета
SELECT [dbo].[Subject].subject_name, [dbo].[ScoreScale].test_score, [dbo].[ScoreScale].rating_score, [dbo].[ScoreScale].sfe
FROM [dbo].[Subject] JOIN [dbo].[ScoreScale] ON [dbo].[Subject].subject_id = [dbo].[ScoreScale].subject_id
WHERE [dbo].[Subject].subject_id = 2


--кількість учасників, які мають 200
SELECT COUNT(DISTINCT [student_id]) AS stud_num
FROM [dbo].[Student]
JOIN  [dbo].[ResultInfo] ON [dbo].[ResultInfo].info_card_id = [dbo].[Student].info_card_id
WHERE [dbo].[ResultInfo].result = 200


--імена тих, хто здавали в 2022
SELECT full_name
FROM [dbo].[Student]
JOIN [dbo].[InformationCard] ON [dbo].[Student].info_card_id = [dbo].[InformationCard].info_card_id
WHERE [dbo].[InformationCard].year_of_receipt = 2022


--кількість людей по роках
SELECT
[dbo].[InformationCard].year_of_receipt, COUNT([dbo].[Student].student_id) AS stud_num
FROM
[dbo].[InformationCard] JOIN [dbo].[Student] ON [dbo].[Student].info_card_id = [dbo].[InformationCard].info_card_id
GROUP BY year_of_receipt


--список тих, хто не брав участь у зно та локація
SELECT [dbo].[Student].full_name, 
([dbo].[TestingLocation].region + ', ' + [dbo].[TestingLocation].district + ', ' + [dbo].[TestingLocation].settlement) AS region
FROM [dbo].[Student] JOIN [dbo].[TestingLocation] ON [dbo].[Student].location_id = [dbo].[TestingLocation].location_id
WHERE [dbo].[Student].participated = 0


--сортування по сумі балів
SELECT [dbo].[Student].full_name, SUM([dbo].[ResultInfo].result) AS sum_result
FROM [dbo].[Student] JOIN [dbo].[ResultInfo] ON [dbo].[Student].info_card_id = [dbo].[ResultInfo].info_card_id
GROUP BY full_name
ORDER BY sum_result DESC


--сортування по середньому балу
SELECT [dbo].[Student].full_name, AVG([dbo].[ResultInfo].result) AS avg_result
FROM [dbo].[Student] JOIN [dbo].[ResultInfo] ON [dbo].[Student].info_card_id = [dbo].[ResultInfo].info_card_id
GROUP BY full_name
ORDER BY avg_result DESC


--кількість людей з двома і більше 200
SELECT COUNT(*) AS stud_num
FROM (
SELECT [student_id]
FROM [dbo].[Student]
JOIN  [dbo].[ResultInfo] ON [dbo].[ResultInfo].info_card_id = [dbo].[Student].info_card_id
WHERE [dbo].[ResultInfo].result = 200
GROUP BY [student_id]
HAVING COUNT(*) > 1) AS students


--кількість людей які подолали поріг по педметах
SELECT
[dbo].[Subject].subject_name, COUNT([dbo].[ResultInfo].subject_id) AS stud_num
FROM [dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
WHERE [dbo].[ResultInfo].result IS NOT NULL
GROUP BY subject_name


--кількість людей які отримали >150 в основну сесію по педметах
SELECT
[dbo].[Subject].subject_name, COUNT([dbo].[ResultInfo].subject_id) AS stud_num
FROM [dbo].[Subject] JOIN [dbo].[ResultInfo] ON [dbo].[Subject].subject_id = [dbo].[ResultInfo].subject_id
WHERE [dbo].[ResultInfo].result >= 150 AND [dbo].[ResultInfo].session_name = 'основна'
GROUP BY subject_name


--ідекс для шкали балів
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


--тригер на додавання учасника (оновлює статистику)
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

--тригер на видалення учасника (оновлює статистику)
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
INSERT INTO [dbo].[Student] ([full_name], [location_id]) VALUES ('Колодько О. А.', 1);
DELETE FROM [dbo].[Student] WHERE [full_name] = 'Колодько О. А.';
