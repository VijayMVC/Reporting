--	------------------------------------------------------------------------------------------------------
--	2019-06-24, Золотенко М.
--	

--	Вертає runtime-значення параметра для звіту
--	
--	
CREATE FUNCTION [Reporting].[fn_get_param_value]
	(
		@ReportId				int,
		@ParamName				varchar(100)
	)
RETURNS VARCHAR(MAX)
AS
BEGIN
	
	--	--------------------------------------------------------------------------------------------------------------------------------------------------------------
	--	
	--	!!! УВАГА !!!
	--	
	--	ТУТ ДУЖЕ КРИТИЧНО, ЩОБ БУВ ХІНТ NOLOCK, ОСКІЛЬКИ ПІД ЧАС ПОБУДОВИ ЗВІТУ ВІДПОВІДНОЮ СЕРЕДОЮ, RUNTIME-ПАРАМЕТРИ ЗМІНЮЮТЬСЯ І БЛОКУЮТЬСЯ ДО КІНЦЯ
	--		ПОБУДОВИ ЗВІТУ
	--		ВІДПОВІДНО, ОНОВЛЕННЯ ДАНИХ З ІНШОЇ СЕСІЇ БУДЕ НЕМОЖЛИВИМ, ЯКЩО НЕ ВИКОРИСТОВУВАТИ ХІНТ NOLOCK
	--	
	
	RETURN	(
				SELECT	T2.PARAMVALUE
				FROM	Reporting.Params T1 WITH (NOLOCK)
				INNER JOIN Reporting.ParamsRuntimeValue T2 WITH (NOLOCK) ON T2.PARAMID = T1.ID
				WHERE	T1.REPORTID = @ReportId
						AND T1.PARAMNAME = @ParamName
			);
END
