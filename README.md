# 📉 Global Layoffs Analysis (2022) — SQL Project

> A data-driven exploration of the 2022–2023 global layoff trends using SQL. This project analyzes cleaned data from [Kaggle's Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022) to extract insights into company-wide job cuts, industry impact, and country-level trends.

---

## 📊 Project Overview

This project is a continuation of a data cleaning task (Project 1) and focuses on **exploratory data analysis (EDA)** using SQL on the cleaned `layoffs_staging2` table.

Using SQL queries, we answer business and economic questions such as:

- Which companies laid off 100% of their workforce?
- Which companies had the most total layoffs?
- What industries and countries were hit the hardest?
- How did layoffs change over time (by year/month)?
- Who were the top layoff contributors each year?

---

## 🧠 Key Insights

- 📌 Some companies raised millions in funding and still laid off all employees.
- 🌍 The U.S. saw the highest total layoffs.
- 🏢 The tech industry dominated layoffs by volume.
- 📆 Layoffs peaked at specific periods and followed economic shifts over time.

---

## 🗃️ Dataset

- **Source**: [Kaggle - Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- **Table Used**: `layoffs_staging2` (Cleaned in Project 1)
- **Columns of interest**:
  - `company`
  - `industry`
  - `country`
  - `total_laid_off`
  - `percentage_laid_off`
  - `funds_raised_millions`
  - `date`

---

## 🔍 SQL Queries Included

Here’s a breakdown of the analysis performed:

### ✅ 1. General Exploration
```sql
SELECT * FROM world_layoffs.layoffs_staging2;
````

### 🔥 2. Companies that laid off 100% of employees

```sql
SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
```

### 🏢 3. Top Companies by Total Layoffs

```sql
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;
```

### 🌎 4. Layoffs by Country

```sql
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;
```

### 📅 5. Yearly Layoff Totals

```sql
SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date);
```

### 🏭 6. Layoffs by Industry

```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
```

### 🗓️ 7. Layoffs per Month + Rolling Total

```sql
WITH DATE_CTE AS (
  SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY dates
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates) AS rolling_total_layoffs
FROM DATE_CTE;
```

### 🥇 8. Top 3 Companies by Layoffs Each Year

```sql
WITH Company_Year AS (
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
  SELECT company, years, total_laid_off,
         DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3 AND years IS NOT NULL;
```

---

## 🧰 Tools & Skills Used

* ✅ SQL (MySQL / PostgreSQL compatible)
* 📊 Data Cleaning & Aggregation
* 📅 Time-based Analysis (`YEAR()`, `SUBSTRING()`)
* 🪄 CTEs & Window Functions
* 🔍 Exploratory Data Analysis (EDA)

---