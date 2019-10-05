--	------------------------------------------------------------------------------------------
--	Золотенко М.
--	
CREATE TABLE [Reporting].[Schedule]
(
	[ID] INT NOT NULL IDENTITY, 
    [REPORTID] INT NOT NULL, 
    [REPORTDATE] DATETIME NULL, 
	[SETTINGS] XML NOT NULL,
    [STATUS] SMALLINT NOT NULL DEFAULT 0, 
		--	ПОТОЧНИЙ СТАТУС ЗВІТУ:
		--		0	-	ОЧІКУЄ ОПРАЦЮВАННЯ
		--		1	-	ОПРАЦЬОВАНО УСПІШНО
		--		2	-	ВІДМІНЕНО
		--		-1	-	ОПРАЦЬОВАНО З ПОМИЛКОЮ
		--		3	-	ОПРАЦЬОВУЄТЬСЯ У ДАННИЙ МОМЕНТ
	[ATTEMPT_NUM]	INT NOT NULL DEFAULT 0,
		--	НОМЕР СПРОБИ
		--		ОСКІЛЬКИ ЛОГІКА ОБРОБКИ ЗВІТУ ДОПУСКАЄ МОЖЛИВІСТЬ, ЩО ОБРОБНИК ЗАДАЧ НЕ ДОЧЕКАЄТЬСЯ ВІДПРАЦЮВАННЯ МАКРОСУ І ПРИПИНИТЬ ЙОГО ВИКОНАННЯ,
		--		ТО БУДЕ ЦІКАВО БАЧИТИ, ЩО ЗВІТ БУВ ПОБУДОВАНИЙ З НЕПЕРШОЇ СПРОБИ (АБО У ПРОЦЕСІ ПОБУДОВИ І ЦЕ ВЖЕ N-ТА СПРОБА)
	[ERROR]	VARCHAR(2000) NULL,

    [CREATED] DATETIME NOT NULL DEFAULT GETDATE(), 
    [CREATOR] VARCHAR(100) NOT NULL DEFAULT USER, 
    [CHANGED] DATETIME NULL, 
    [CHANGER] VARCHAR(100) NULL, 

    CONSTRAINT [PK_REPORTING_SCHEDULE] PRIMARY KEY ([ID]) 
)
