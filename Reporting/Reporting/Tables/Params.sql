--	------------------------------------------------------------------------------------------------------
--	2019-06-24, Золотенко М.
--	

--	Перелік параметрів, що використовуються для побудови звіту
--	
--	
CREATE TABLE [Reporting].[Params]
(
	[ID] INT NOT NULL , 
    [REPORTID] INT NOT NULL, 
    [PARAMNAME] VARCHAR(100) NOT NULL, 
    [DEFAULTVALUE] VARCHAR(2000) NULL, 
    [DESCRIPTION] VARCHAR(2000) NULL, 
    CONSTRAINT [PK_REPORTING_PARAMS] PRIMARY KEY ([ID]), 
    CONSTRAINT [UQ_REPORTING_PARAMS__REPORTID_PARAMNAME] UNIQUE ([REPORTID], [PARAMNAME]), 
    CONSTRAINT [FK_REPORTING_PARAMS__REPORTID] FOREIGN KEY ([REPORTID]) REFERENCES [Reporting].[Report]([ID])
)
