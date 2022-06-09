-- Comparing California and Texas income and education level percentages
-- US census data was collected from https://data.census.gov and searching for S1501 education levels and DP03 for population data.
-- Look at meta data to get names for column codes

-- CA and TX population education census

SELECT TOP 5 *
FROM PortfolioProjects.dbo.US_census_education_csv

-- S1501_C02_009E = Estimate!!Percent!Population 25 years and over!!High school graduate (includes equivalency)
-- S1501_C02_011E = Estimate!!Percent!Population 25 years and over!!Associate's degree
-- S1501_C02_012E = Estimate!!Percent!Population 25 years and over!!Bachelor's degree
-- S1501_C02_014E = Estimate!!Percent!Population 25 years and over!!High school graduate or higher
-- S1501_C02_015E = Estimate!!Percent!Population 25 years and over!!Bachelor's degree or higher

SELECT TOP 5 NAME, S1501_C02_009E, S1501_C02_011E, S1501_C02_012E, S1501_C02_014E, S1501_C02_015E
FROM PortfolioProjects.dbo.US_census_education_csv



--- Texas Income data

-- DP03_0055PE = Percent Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$25,000 to $34,999
-- DP03_0056PM = Percent Margin of Error!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$35,000 to $49,999
-- DP03_0057PE = Percent Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$50,000 to $74,999
-- DP03_0058PE = Percent Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$75,000 to $99,999
-- DP03_0059PE = Percent Estimate!!INCOME AND BENEFITS (IN 2018 INFLATION-ADJUSTED DOLLARS)!!Total households!!$100,000 to $149,999

SELECT TOP 5 NAME ,DP03_0055PE, DP03_0056PM, DP03_0057PE ,DP03_0058PE, DP03_0059PE
FROM PortfolioProjects.dbo.US_census_texas_counties_csv

--- California income data (same keys as above)

SELECT TOP 5 NAME ,DP03_0055PE, DP03_0056PM, DP03_0057PE ,DP03_0058PE, DP03_0059PE
FROM PortfolioProjects.dbo.US_census_california_counties_csv

--- Union the Income data and join with education data

WITH CTE
(NAME ,DP03_0055PE, DP03_0056PM, DP03_0057PE ,DP03_0058PE, DP03_0059PE)
AS
(
SELECT NAME ,DP03_0055PE, DP03_0056PM, DP03_0057PE ,DP03_0058PE, DP03_0059PE
FROM PortfolioProjects.dbo.US_census_california_counties_csv
UNION 
SELECT NAME ,DP03_0055PE, DP03_0056PM, DP03_0057PE ,DP03_0058PE, DP03_0059PE
FROM PortfolioProjects.dbo.US_census_texas_counties_csv
),
CTE2
(NAME, S1501_C02_009E, S1501_C02_011E, S1501_C02_012E, S1501_C02_014E, S1501_C02_015E) 
AS 
(
SELECT NAME, S1501_C02_009E, S1501_C02_011E, S1501_C02_012E, S1501_C02_014E, S1501_C02_015E
FROM PortfolioProjects.dbo.US_census_education_csv
)
SELECT 
CTE.NAME, S1501_C02_009E, S1501_C02_011E, S1501_C02_012E, S1501_C02_014E, 
S1501_C02_015E,DP03_0055PE, DP03_0056PM, DP03_0057PE ,DP03_0058PE, DP03_0059PE
--INTO #temp
FROM CTE
JOIN CTE2
ON CTE.NAME = CTE2.NAME

--- Temp table to work from 
SELECT *
FROM #temp

