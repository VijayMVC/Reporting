--	---------------------------------------------------------------------------------------------------------------------------------------
--	
--		2019-03-19, ЗОЛОТЕНКО М.
--	
--		ДОДАЄ ЗВІТ ДО ЧЕРГИ
--		
--	
CREATE PROCEDURE [Reporting].[SP_ADD_SCHEDULE]
	@aREPORTID			INT,
	@aREPORTDATE		DATETIME	=	NULL,
	@aSETTINGS			XML			=	''
WITH ENCRYPTION
AS
	SET NOCOUNT ON;

	INSERT	Reporting.Schedule
		(REPORTID,REPORTDATE,SETTINGS)
	VALUES	(@aREPORTID,@aREPORTDATE,@aSETTINGS)

RETURN 0
