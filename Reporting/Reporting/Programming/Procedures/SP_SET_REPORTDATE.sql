--	---------------------------------------------------------------------------------------------------------------------------------------
--	
--		2019-03-19, ЗОЛОТЕНКО М.
--	
--		ВСТАНОВЛЮЄ ЗВІТНУ ДАТУ ДЛЯ ЗАДАНОГО REPORTID
--		
--			ОСНОВНЕ ПРИЗНАЧЕННЯ ПРОЦЕДУРИ - ДЛЯ ЗАДАНОГО ЗВІТУ ВСТАНОВИТИ НА СЕРВЕРІ ЗВІТНУ ДАТУ, ДЛЯ ЯКОЇ БУДЕ БУДУВАТИСЬ ЗВІТ.
--			ДАТА МАЄ ВСТАНОВЛЮВАТИСЬ У ВІДПОВІДНІЙ ТАБЛИЦІ З ПОТОЧНИМИ НАЛАШТУВАННЯМИ І БУДЕ ВИКОРИСТОВУВАТИСЬ ШАБЛОНОМ ЗВІТУ.
--	
--		
CREATE PROCEDURE [Reporting].[SP_SET_REPORTDATE]
	@aREPORTID		INT,
	@aREPORTDATE	DATETIME
WITH ENCRYPTION
AS
	SET NOCOUNT ON;

	DECLARE @TRANCNT	INT = @@TRANCOUNT;

	IF @TRANCNT <> 0
		SAVE TRANSACTION REPORTING_SP_SET_REPORTDATE;
	ELSE
		BEGIN TRANSACTION;

	BEGIN TRY
		
		DELETE	T
		FROM	[Reporting].[RUNTIME_SETTINGS] T
		WHERE	T.REPORTID = @aREPORTID
				AND T.SETTINGNAME = 'REPORTDATE';

		UPDATE	T
		SET		T.VALUE = CONVERT(VARCHAR(20), @aREPORTDATE, 112)
		FROM	[Reporting].[RUNTIME_SETTINGS] T
		WHERE	T.REPORTID = @aREPORTID

		IF @TRANCNT = 0  
            COMMIT TRANSACTION;  

		RETURN 0;

	END TRY
	BEGIN CATCH
		
		 IF @TRANCNT = 0
            ROLLBACK TRANSACTION;  
        ELSE  
            IF XACT_STATE() <> -1  
                ROLLBACK TRANSACTION ProcedureSave;

        DECLARE @ErrorMessage NVARCHAR(4000);  
        DECLARE @ErrorSeverity INT;  
        DECLARE @ErrorState INT;  
  
        SELECT @ErrorMessage = ERROR_MESSAGE();  
        SELECT @ErrorSeverity = ERROR_SEVERITY();  
        SELECT @ErrorState = ERROR_STATE();  
  
        RAISERROR	(
						@ErrorMessage,	-- Message text.  
						@ErrorSeverity, -- Severity.  
						@ErrorState		-- State.  
					) WITH NOWAIT;

	END CATCH;
