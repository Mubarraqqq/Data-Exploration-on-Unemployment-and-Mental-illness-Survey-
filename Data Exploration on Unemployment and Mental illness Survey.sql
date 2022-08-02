
----------------------------------------Unemployment and Mental illness Survey Data Exploration---------------------------------------- 



-------------------Dataset showing a random survey carried out on 334 individuals on Unemployment and Mental illness-------------------

-----A preview of the already cleaned dataset
SELECT *
FROM [Modify]..[Clean Data]



-------------------[1]-Previewing the number of female and male individuals that carried out the survey

SELECT Gender, COUNT(Gender)
FROM [Modify]..[Clean Data]
GROUP BY Gender
--Conclusion:
--from the above query we can deduce that:
-- No of Female = 176
--No of Male = 158
 



-------Showing a preview of the Region, Percentage of unemployment per region and its average annual income

SELECT [Region], ROUND(AVG([Annual income (including any social welfare programs) in USD]),1) as Avg_Annual_Income_Per_Region, 
ROUND(((SUM([I am unemployed])/COUNT(Region))*100),2)  AS Percentage_of_Unemployment
FROM [Modify]..[Clean Data]
WHERE Region <> '0'
GROUP BY Region 
ORDER BY ROUND(AVG([Annual income (including any social welfare programs) in USD]),1) DESC


-------------------[2]-Creating a Temp table for the above query to temporarily store data in a table
DROP TABLE IF EXISTS #Temp_Region  
CREATE TABLE #Temp_Region
(
Region nvarchar(256),
[Avg Annual Income In Thousand] float,
[Percentage of Unemployed Citizens] float
)

INSERT INTO #Temp_Region 
SELECT [Region], ROUND(AVG([Annual income (including any social welfare programs) in USD]),1) as Avg_Annual_Income_Per_Region, 
ROUND(((SUM([I am unemployed])/COUNT(Region))*100),2)  AS Percentage_of_Unemployment
FROM [Modify]..[Clean Data]
WHERE Region <> '0'
GROUP BY Region 
ORDER BY ROUND(AVG([Annual income (including any social welfare programs) in USD]),1) DESC


SELECT *
FROM #Temp_Region
--Conclusion:
--the query above shows the average annual income per region and the analogy with its percentage of unemployed citizens
--with this data we can compare the average income each region rakes in annually with the percentage of unemployed citizens to see if there's a positive correlation



-------Adding a new column for the sum of varieties of mental health issues per individual
ALTER TABLE [Modify]..[Clean Data]
ADD [No of Mental Health Issues] int

UPDATE [Modify]..[Clean Data]
SET [No of Mental Health Issues] = ([Lack of concentration]
+[Anxiety]+[Depression]+[Obsessive thinking]+[Mood swings]+[Panic attacks]+[Compulsive behavior])


-------Previewing the  table
SELECT *
FROM [Modify]..[Clean Data]





-------------------[3]-Using stored procedures to create a table that consists of columns having information contributing to mental health issues
--Using stored procedures to find the trends that occurs in individuals that have been identified with having mental illness
CREATE PROCEDURE New_DB
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

SELECT *
FROM #Mental_Table
ORDER BY Identified_having_mental_illness DESC

EXEC New_DB @Identified_having_mental_illness = 1

--Conclusion:
/*From the data been queried, we can conclude that individuals identified with having mental illness have previously 
had a number of mental health issues like panic attacks, depressions, anxiety etc. and majority have been unemployed hence deducing that 
the cause of unemployment brought about the mental health issues thus drawing a relationship between unemployment and mental health issues*/
--In the query above, the introduction of Stored Procedures was used to reduce network traffic and increase the performance





-------Previewing the Education column categories
SELECT DISTINCT([Education])
FROM [Modify]..[Clean Data]

-------------------[4]-Writing a query that shows the Level of education and the chances of getting employed
SELECT [Education], [I am currently employed at least part-time], ROUND((SUM([I am currently employed at least part-time]) OVER(PARTITION BY Education)/
COUNT([I am currently employed at least part-time]) OVER(PARTITION BY Education))*100,2) as chances_of_being_employed
FROM [Modify]..[Clean Data]
ORDER BY [Education]
--Conclusion:
/*The query above shows the chances of getting a job with respect to the degree you possess. We can deduce from the query that, the higher the degree, the 
higher the chance of being accepted e.g. Individuals with 'Some Phd' (i.e. Ongoing Phd) have a 100% chance of being employed while Individuals having just a High School or GED degree
hold a 40% chance of being employed.
Although this isn't showing a linear graphical representation  i.e. Completed Phd(69.4%) has a lesser chance of gaining employment than someone with a Completed Undergraduate degree(71%).
This inference is caused by limited amount of data to arrive at a rational conclusion*/



-------Previewing the Age column categories
SELECT DISTINCT(Age)
FROM [Modify]..[Clean Data]

-------------------[5]-Using Common Table Expressions to view columns that have citizens that are legally disabled with any other selected columns to detect any trends
WITH CTE_data AS
(
SELECT [I am legally disabled], [I receive food stamps], [i am on section 8 housing], [No of Mental Health Issues], [Age]
, COUNT(Age) OVER (PARTITION BY Age) AS [Age Count]
FROM [Modify]..[Clean Data]
WHERE [I am legally disabled] = 1)


SELECT [I am legally disabled], [Age], COUNT(Age) OVER (PARTITION BY Age) AS [Age Count]
FROM CTE_data
ORDER BY [I am legally disabled] DESC, Age 

--Conclusion
/*
From the data queried showing the legally disabled citizens, their ages and their Count, 
we can deduce that the legally disabled people are mostly found in older people than their younger counterpart
*/





-------------------[6]-Getting the device type and the number of people using them 
SELECT [Device Type], COUNT([Device Type]) as No_of_devices
FROM [Modify]..[Clean Data]
GROUP BY [Device Type]
ORDER BY ([Device Type])

--Conclusion
/* from the query above we can deduce that;
93 people use the [Android Phone / Tablet], 93 people use [iOS Phone / Tablet], 24 use [MacOS Desktop / Laptop]
122 people use [Windows Desktop / Laptop] while 2 people use Other device type that was not listed in the dataset
*/


-------------------[7]-Deducing the number of people who owns a computer and have regular access to the internet

SELECT *
FROM [Modify]..[Clean Data]
WHERE [I have my regular access to the internet] = 1
AND [I have my own computer separate from a smart phone] =1

--Conclusion:
/*From the data queried, we can deduce that we have 286 people that owned a laptop and have regular access to the internet out of the 334 individuals survey*/





