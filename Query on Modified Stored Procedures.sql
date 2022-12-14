USE [Modify]
GO
/****** Object:  StoredProcedure [dbo].[New_DB]    Script Date: 02/08/2022 18:56:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[New_DB]
@Identified_having_mental_illness int
AS 

CREATE TABLE #Mental_Table
(
[No of Mental Health Issues] int,
Identified_having_mental_illness int,
[Previously hospitalized for my mental illness] int,
[No. of days were you hospitalized for your mental illness] int,
[No of times were you hospitalized for your mental illness] int,
[Unemployed] int,
Gender nvarchar(256)
)

INSERT INTO #Mental_Table
SELECT [No of Mental Health Issues], [I identify as having a mental illness],
[I have been hospitalized before for my mental illness],[How many days were you hospitalized for your mental illness],
[How many times were you hospitalized for your mental illness], [I am unemployed],Gender
FROM [Modify]..[Clean Data]
WHERE Identified_having_mental_illness=@Identified_having_mental_illness
