/*
COVID-19 Data Exploration

Skills used: Windows Functions, Aggregate Functions, Cast, Joins, Partition By, Creating a View, Data Types Conversion

*/

-- Total cases vs. Population
-- Shows the total infection count, population, and percent of the population infected

SELECT YEAR(date) AS year, location, population, MAX(CAST(total_cases AS DECIMAL)) AS highest_infection_count, (MAX(CAST(total_cases AS DECIMAL))/population)*100 AS percent_pop_infected
FROM covid_deaths 
WHERE continent = 'North America' 
GROUP BY YEAR(date), location,  population
HAVING (MAX(CAST(total_cases AS DECIMAL))/population)*100 IS NOT NULL
ORDER BY year

-- Total death vs. population 
-- Shows what percentage of the population has died from Covid

SELECT YEAR(date) AS year,location, population, MAX(CAST(total_deaths AS DECIMAL)) AS total_deaths, MAX(CAST(total_deaths AS DECIMAL)/population)*100 AS pecent_pop_death
FROM covid_deaths 
WHERE continent = 'North America'
GROUP BY YEAR(date),location, population
ORDER BY year

-- Total population vs vaccinations 
-- Shows the cumulative number of the Population that has received at least one covid vaccination shot in that Country

Select death.location, death.date, death.population, vacc.new_vaccinations
, SUM(CONVERT(int,vacc.new_vaccinations)) OVER (Partition by death.Location Order by death.location, death.Date) as accumlating_people_vaccinated
From covid_deaths AS death
Join covid_vaccinations AS vacc
	On death.location = vacc.location
	and death.date = vacc.date
where death.continent = 'North America' AND new_vaccinations IS NOT NULL
order by location, date


-- Cumulative cases, deaths, and population 
-- Shows the total cases, total deaths, and population by Country

SELECT YEAR(death.date) AS year, death.location, SUM(death.new_cases) as total_cases, SUM(death.new_deaths) as total_deaths, death.population
FROM covid_deaths AS death
JOIN covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent = 'North America'
GROUP BY YEAR(death.date), death.location, death.population
ORDER BY death.location

-- New tests vs cases 
-- Shows the percentage of COVID tests that resulted in a new COVID case
-- Some values display cases, not tests, that was before tests were available

SELECT death.location, YEAR(death.date) AS year, SUM(CAST(vacc.new_tests AS INT)) AS total_tests, SUM(death.new_cases) AS total_cases,
    (SUM(death.new_cases) / NULLIF(SUM(CAST(vacc.new_tests AS DECIMAL)), 0)) * 100 AS percent_cases_to_tests
FROM covid_deaths AS death
JOIN covid_vaccinations AS vacc
    ON death.location = vacc.location
    AND death.date = vacc.date
WHERE death.continent = 'North America' AND total_tests IS NOT NULL
GROUP BY death.location, YEAR(death.date)
ORDER BY death.location


-- Hospital admissions vs population (Only available in the United States)
-- Shows the percentage of the population that has been admitted to the Hospital due to Covid

SELECT death.location, YEAR(death.date) AS year, death.weekly_hosp_admissions AS hospital_admissions, death.population,
	CAST(death.weekly_hosp_admissions AS INT)/NULLIF(MAX(death.population),0)*100 AS percent_admissions_to_population
FROM covid_deaths AS death
JOIN covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent = 'North America' AND death.location= 'United States'
GROUP BY death.location, YEAR(death.date), population, death.weekly_hosp_admissions
ORDER BY death.location

-- Cases vs people vaccinated 
-- Shows the percentage of vaccinations related to the number of cases. The goal is to see if COVID cases increase as the number of people vaccinated goes up

SELECT death.location, death.date, death.total_cases, vacc.people_vaccinated, CAST(death.total_cases AS DECIMAL)/NULLIF(vacc.people_vaccinated ,0)*100 AS percent_cases_vs_vaccinated
FROM covid_deaths AS death
JOIN covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent = 'North America' AND CAST(death.total_cases AS DECIMAL)/NULLIF(vacc.people_vaccinated ,0)*100 IS NOT NULL
ORDER BY location, death.date

-- Creating a temp table for easier analysis in the future
DROP TABLE IF EXISTS #percent_population_vaccinated
CREATE TABLE #percent_population_vaccinated
(
location nvarchar(255),
date datetime,
population numeric, 
new_vaccinations numeric,
rolling_count_people_vaccinated numeric
)

INSERT INTO #percent_population_vaccinated
SELECT death.location, death.date, death.population, vacc.new_vaccinations,
	SUM(CONVERT(int, vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_count_people_vaccinated
FROM covid_deaths AS death
JOIN covid_vaccinations AS vacc
	ON death.location = vacc.location
	AND death.date = vacc.date
WHERE death.continent = 'North America'
ORDER BY 1,2

SELECT *, (rolling_count_people_vaccinated/population)*100
FROM #percent_population_vaccinated


-- Creating View to store data for later use
Create View PercentPopulationVaccinated as
	SELECT death.location, death.date, death.population, vacc.new_vaccinations,
		MAX(CONVERT(int, vacc.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_count_people_vaccinated
	FROM covid_deaths AS death
	JOIN covid_vaccinations AS vacc
		ON death.location = vacc.location
		AND death.date = vacc.date
	WHERE death.continent = 'North America'
