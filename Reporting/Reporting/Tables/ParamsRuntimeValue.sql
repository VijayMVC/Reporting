--	------------------------------------------------------------------------------------------------------
--	2019-06-24, Золотенко М.
--	

--	Значення параметрів звіту під час побудови звіту 
--	
--	
CREATE TABLE [Reporting].[ParamsRuntimeValue]
(
	[PARAMID] INT NOT NULL , 
    [PARAMVALUE] VARCHAR(MAX) NULL, 
    CONSTRAINT [PK_REPORTING_PARAMSRUNTIMEVALUE] PRIMARY KEY ([PARAMID]), 
    CONSTRAINT [FK_REPORTING_PARAMSRUNTIMEVALUE__PARAMID] FOREIGN KEY ([PARAMID]) REFERENCES [Reporting].[Params]([ID])
)
