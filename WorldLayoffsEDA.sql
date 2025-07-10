-- Data --> https://www.kaggle.com/datasets/swaptr/layoffs-2022

-- EDA for the cleaned data set I used in project 1 

SELECT * 
FROM world_layoffs.layoffs_staging2
;

-- Which companies had 1, which is 100 percent of the company being laid off
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
;

-- if we order by `funds_raised_millions` column, we can see how big some of these companies were
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

-- Top 5 companies with the biggest single Layoff
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging2
ORDER BY 2 DESC
LIMIT 5
;

-- Top 10 companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10
;


-- Grouping by country, we can see how many employees were laid off in each country from highest to lowest numbers in the time frame of this data set
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;

-- This query shows how many people were laid off in a single year
SELECT YEAR(date), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC
;

-- This query shows how many people were laid off based on industry from highest to lowest
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
;

-- Above is a query that shows companies with the most Layoffs in the whole timeframe of the data set. 
-- This query shows how the highest companies doing layoffs PER YEAR.
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC
;

-- Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- Rolling Total of layoffs 
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC
;