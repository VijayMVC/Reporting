CREATE VIEW [Reporting].[v_schedule]
AS
	SELECT	V.ID,
			V.TEMPLATEPATH,
			V.SAVEPATH,
			V.EMAILLIST,
			V.STATUS
	FROM	(
				VALUES	(1, '\\fileserverlviv\backup\Кредитні ризики\Max\! Сектор Звітності\!Excel\_MacroTemplate.xlsm','C:\Max\Result.xlsx','maksym.zolotenko@ideabank.ua', 0),
						(2, 'C:\Max\_MacroTemplate1.xlsm','C:\Max\Result1.xlsx','maksym.zolotenko@ideabank.ua', 0),
						(3, 'C:\Max\_MacroTemplate2.xlsm','C:\Max\Result2.xlsx','maksym.zolotenko@ideabank.ua', 0)
			) AS V(ID, TEMPLATEPATH, SAVEPATH, EMAILLIST, STATUS)
