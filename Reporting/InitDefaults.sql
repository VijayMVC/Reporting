/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/


--	------------------------------------------------------------------------------------------------------------------
--	[Reporting].[ReportType]
--	
;WITH CTE AS
	(
		SELECT	1															AS	"ID",
				'EXCEL'														AS	"NAME",
				'Звіт на базі Excel-шаблону.'								AS	"DESCRIPTION"
		UNION ALL
		SELECT	2															AS	"ID",
				'ONLINE'													AS	"NAME",
				'Online-звіт.'												AS	"DESCRIPTION"
		UNION ALL
		SELECT	3															AS	"ID",
				'ІНФОРМАЦІЙНЕ ПОВІДОМЛЕННЯ'									AS	"NAME",
				'Інформаційне сповіщення про настання якоїсь події.'		AS	"DESCRIPTION"
	
	)
INSERT	[Reporting].[ReportType]
	(
		ID,NAME,DESCRIPTION
	)
SELECT	T1.ID,
		T1.NAME,
		T1.DESCRIPTION
FROM	CTE T1
LEFT JOIN [Reporting].[ReportType] T2 ON T2.ID = T1.ID
WHERE	T2.ID IS NULL

--	------------------------------------------------------------------------------------------------------------------
--	[Reporting].[ReportType]
--	
;WITH CTE AS
	(
		SELECT	0								AS	"ID",
				'NOT SET'						AS	"NAME",
				'.'								AS	"DESCRIPTION"
		UNION ALL
		SELECT	1								AS	"ID",
				'DAILY'							AS	"NAME",
				'.'								AS	"DESCRIPTION"
		UNION ALL
		SELECT	2								AS	"ID",
				'WEEKLY'						AS	"NAME",
				'.'								AS	"DESCRIPTION"
		UNION ALL
		SELECT	3								AS	"ID",
				'MONTHLY'						AS	"NAME",
				'.'								AS	"DESCRIPTION"
	
	)
INSERT	[Reporting].[Periodicity]
	(
		ID,NAME,DESCRIPTION
	)
SELECT	T1.ID,
		T1.NAME,
		T1.DESCRIPTION
FROM	CTE T1
LEFT JOIN [Reporting].[Periodicity] T2 ON T2.ID = T1.ID
WHERE	T2.ID IS NULL