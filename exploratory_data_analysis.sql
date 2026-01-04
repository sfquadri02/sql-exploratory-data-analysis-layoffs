-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging;

-- Looking at Percentage of layoffs

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging;

-- The companies that had 1 which is basically 100 percent of their company laid off

SELECT *
FROM layoffs_staging
WHERE percentage_laid_off = 1;

-- these are mostly startups or maybe these companies went out of business during this time

-- then if we order by funds_raised we can see how big some of these companies were

SELECT *
FROM layoffs_staging
WHERE percentage_laid_off = 1
ORDER BY funds_raised DESC;

-- BritishVolt looks like the company which raised most funds

-- companies with the most total layoffs

SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;

-- industries with the most total layoffs

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;

-- countries with the most total layoffs

SELECT country, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY country
ORDER BY 2 DESC;

-- total  layoffs by year to identify yearly trends and peak layoff periods

SELECT YEAR(date) AS Year, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY YEAR(date)
ORDER BY 1 DESC;

-- total  layoffs by company stage

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY stage
ORDER BY 1 DESC;

-- Rolling Total Layoffs by Month

SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY `Month`
ORDER BY 1 ASC;

WITH rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging
GROUP BY `Month`
ORDER BY 1 ASC
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM rolling_total;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company
ORDER BY 2 DESC;

-- Rolling Total Layoffs by Company and Year

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`) AS Year, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
ORDER BY years ASC;

