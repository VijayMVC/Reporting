CREATE TABLE [Reporting].[Report]
(
	[ID] INT NOT NULL IDENTITY, 
    [NAME] VARCHAR(200) NOT NULL, 
	[DESCRIPTION] VARCHAR(2000) NOT NULL, 
	[REPORTTYPEID] INT NOT NULL,
		--	ТИП ЗВІТУ:
		--		*	EXCEL
		--		*	ONLINE
		--		*	ІНФОРМАЦІЙНЕ ПОВІДОМЛЕННЯ
	[PERIODICITYID] INT NOT NULL,
		--	ПЕРІОДИЧНІСТЬ ПОБУДОВИ ЗВІТУ
		--		*	ЩОДЕННИЙ
		--		*	ТИЖНЕВИЙ
		--		*	МІСЯЧНИЙ
		--		*	ІНШЕ/НЕ ВИЗНАЧЕНО
	[URL_MAIN] VARCHAR(2000) NULL, 
	[URL_FILE] VARCHAR(200) NULL, 
    [TEMPLATEPATH] VARCHAR(2000) NULL,
	[TEMPLATEFILE] VARCHAR(200) NULL,
	[SAVEPATH] VARCHAR(2000) NULL,
	[SAVEFILE] VARCHAR(200) NULL,
	[FL_DISABLED] BIT NOT NULL DEFAULT 0,
		--	ОЗНАКА ТОГО, ЩО ЗВІТ ВІДКЛЮЧЕНО:
		--		1 - ВІДКЛЮЧЕНО
		--		0 - НЕ ВІДКЛЮЧЕНО
	[SSRS_CAPTION] VARCHAR(200) NULL,
	[SSRS_NUM] VARCHAR(50) NULL,
	[Z_REPORTID] INT NULL,
	[FL_ATTACHMENT] BIT NOT NULL DEFAULT 0,
	[EMAIL_TEXT_TEMPLATE] VARCHAR(MAX) NULL,

	[CREATED] DATETIME NOT NULL DEFAULT GETDATE(), 
    [CREATOR] VARCHAR(100) NOT NULL DEFAULT USER, 
    [CHANGED] DATETIME NULL, 
    [CHANGER] VARCHAR(100) NULL, 

    CONSTRAINT [PK_REPORTING_REPORT] PRIMARY KEY ([ID]), 
    CONSTRAINT [UQ_REPORTING_REPORT__NAME] UNIQUE ([NAME]), 
		-- ЗАБЕЗПЕЧУЄМО, ЩОБ ДЛЯ ВСІХ НЕІНФОРМАЦІЙНИХ ЗВІТІВ БУЛО ЗАДАНО АБО ПОСИЛАННЯ НА ОНЛАЙН ЗВІТ АБО ПОСИЛАННЯ НА МЕРЕЖУ
    CONSTRAINT [CK_REPORTING_REPORT__URL_NET] CHECK (CASE WHEN [URL_MAIN] IS NULL AND [SAVEPATH] IS NULL AND REPORTTYPEID != 1 THEN 0 ELSE 1 END = 1), 
		-- ЗАБЕЗПЕЧУЄМО, ЩОБ НЕ БУЛО ВИПАДКІВ, КОЛИ ДЛЯ ОДНОГО ЗВІТУ ЗАДАНО І ПОСИЛАННЯ НА ОНЛАЙН ЗВІТ І НА МЕРЕЖЕВИЙ
    CONSTRAINT [CK_REPORTING_REPROT__URL_NET2] CHECK (CASE WHEN [URL_MAIN] IS NOT NULL AND [SAVEPATH] IS NOT NULL THEN 0 ELSE 1 END = 1), 
    CONSTRAINT [FK_REPORTING_REPORT__REPORTTYPEID] FOREIGN KEY ([REPORTTYPEID]) REFERENCES [Reporting].[ReportType]([ID]), 
    CONSTRAINT [FK_REPORTING_REPORT__PERIODICITYID] FOREIGN KEY ([PERIODICITYID]) REFERENCES [Reporting].[Periodicity]([ID]), 
		--	ЯКЩО ОСНОВНИЙ ОНЛАЙН ШЛЯХ НЕ НУЛЬОВИЙ, ТО І НАЗВА ФАЙЛУ МАЄ БУТИ НАЯВНОЮ. І НАВПАКИ.
    CONSTRAINT [CK_REPORTING_REPORT__URL_MAIN__URL_FILE] CHECK (CASE WHEN ([URL_MAIN] IS NOT NULL AND [URL_FILE] IS NULL) OR ([URL_MAIN] IS NULL AND [URL_FILE] IS NOT NULL)THEN 0 ELSE 1 END = 1)
)

GO

CREATE TRIGGER [Reporting].[TRG_REPORTING_REPORT]
    ON [Reporting].[Report]
    FOR DELETE, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;
		/*
		--	ЯКЩО DELETE
		IF NOT EXISTS(SELECT 1 FROM inserted)
			INSERT	Reporting.ReportHistory
				(
					REPORTID,NAME,DESCRIPTION,SETTINGS,FL_DISABLED,PERIODICITY,REPORTTYPE,CREATED,CREATOR,CHANGED,CHANGER
				)
			SELECT	ID,NAME,DESCRIPTION,SETTINGS,FL_DISABLED,PERIODICITY,REPORTTYPE,CREATED,CREATOR,CHANGED,CHANGER
			FROM	deleted;
		--	ЯКЩО UPDATE
		ELSE
		BEGIN
			INSERT	Reporting.ReportHistory
				(
					REPORTID,NAME,DESCRIPTION,SETTINGS,FL_DISABLED,PERIODICITY,REPORTTYPE,CREATED,CREATOR,CHANGED,CHANGER
				)
			SELECT	ID,NAME,DESCRIPTION,SETTINGS,FL_DISABLED,PERIODICITY,REPORTTYPE,CREATED,CREATOR,CHANGED,CHANGER
			FROM	deleted
			
			EXCEPT
			
			SELECT	ID,NAME,DESCRIPTION,SETTINGS,FL_DISABLED,PERIODICITY,REPORTTYPE,CREATED,CREATOR,CHANGED,CHANGER
			FROM	inserted;

			UPDATE	T1
			SET		T1.CHANGED = GETDATE(),
					T1.CHANGER = USER
			FROM	Reporting.Report T1
			INNER JOIN	(
							SELECT	ID,NAME,DESCRIPTION,SETTINGS,FL_DISABLED,PERIODICITY,REPORTTYPE,CREATED,CREATOR,CHANGED,CHANGER
							FROM	deleted
			
							EXCEPT
			
							SELECT	ID,NAME,DESCRIPTION,SETTINGS,FL_DISABLED,PERIODICITY,REPORTTYPE,CREATED,CREATOR,CHANGED,CHANGER
							FROM	inserted
						) T2 ON T2.ID = T1.ID
		END
		*/
    END
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Основна частина URL адреси для онлайн-звітів',
    @level0type = N'SCHEMA',
    @level0name = N'Reporting',
    @level1type = N'TABLE',
    @level1name = N'Report',
    @level2type = N'COLUMN',
    @level2name = N'URL_MAIN'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Файл онлайн-звіту',
    @level0type = N'SCHEMA',
    @level0name = N'Reporting',
    @level1type = N'TABLE',
    @level1name = N'Report',
    @level2type = N'COLUMN',
    @level2name = N'URL_FILE'