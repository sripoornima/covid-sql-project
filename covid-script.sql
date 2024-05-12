/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT *
FROM covidFinal.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3,4;

-- Data to work with
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covidFinal.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covidFinal.covid_deaths
WHERE location='India' 
AND continent IS NOT NULL
ORDER BY 1,2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT location, date, total_cases, total_deaths, (total_deaths/population)*100 as ContractionPercentage
FROM covidFinal.covid_deaths
-- WHERE location='India' 
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/population))*100 AS MaxContractionPercentage
FROM covidFinal.covid_deaths
-- WHERE location='India' 
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 1,2;

-- Countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM covid_deaths
-- WHERE location='india'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- There are still some continents with blank spaces as values which should be corrected to NULL values
UPDATE covid_deaths
SET continent = NULL
WHERE continent = '';

-- BY CONTINENT
SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM covid_deaths
WHERE location='india'
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

SELECT location, MAX(CAST(total_deaths AS UNSIGNED)) AS TotalDeathCount
FROM covid_deaths
-- WHERE location='india'
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- GLOBAL NUMBERS
-- Reference for DeathPercentage
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covidFinal.covid_deaths
-- WHERE location='India' 
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- group by date, sum of new cases gives us total cases
SELECT date, SUM(new_cases) -- , total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM covidFinal.covid_deaths
-- WHERE location='India' 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- calculation of death percentage in relation to number of cases
SELECT date, SUM(new_cases) as total_cases_new, SUM(new_deaths) AS total_deaths_new, SUM(new_deaths)/SUM(new_cases)*100 AS  GlobalDeathPercentage
FROM covidFinal.covid_deaths
-- WHERE location='India' 
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- overall calculation of death percentage
SELECT SUM(new_cases) as total_cases_new, SUM(new_deaths) AS total_deaths_new, SUM(new_deaths)/SUM(new_cases)*100 AS  GlobalDeathPercentage
FROM covidFinal.covid_deaths
-- WHERE location='India' 
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1,2;

-- Moving on to vaccinations table
SELECT * FROM covidFinal.covid_vaccination;

-- Joining both tables on location and date
SELECT * FROM covidFinal.covid_deaths dea
JOIN covidFinal.covid_vaccination vac
	ON dea.location = vac.location 
	AND dea.date = vac.date;
    
-- Total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM covidFinal.covid_deaths dea
JOIN covidFinal.covid_vaccination vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- Rolling calculations of vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinatedRolling
FROM covidFinal.covid_deaths dea
JOIN covidFinal.covid_vaccination vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;

-- USE CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, PeopleVaccinatedRolling)
AS (SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinatedRolling
FROM covidFinal.covid_deaths dea
JOIN covidFinal.covid_vaccination vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3)
SELECT *, (PeopleVaccinatedRolling/population)*100
FROM PopvsVac;

-- TEMP TABLE
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TABLE PercentPopulationVaccinated
(
	continent varchar(255),
     location varchar(255),
     date datetime,
     population numeric,
     new_vaccinations numeric,
     PeopleVaccinatedRolling numeric
 );

INSERT INTO PercentPopulationVaccinated (continent, location, date, population, new_vaccinations, PeopleVaccinatedRolling)
SELECT dea.continent, dea.location, dea.date, dea.population,
       NULLIF(vac.new_vaccinations, '') AS new_vaccinations,
       SUM(NULLIF(vac.new_vaccinations, '')) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinatedRolling
FROM covidFinal.covid_deaths dea
JOIN covidFinal.covid_vaccination vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


SELECT *, (PeopleVaccinatedRolling/population)*100
FROM PercentPopulationVaccinated;

-- creating a view to store data for later visualisations
CREATE VIEW PeopleVaccinatedRolling AS
SELECT dea.continent, dea.location, dea.date, dea.population,
       NULLIF(vac.new_vaccinations, '') AS new_vaccinations,
       SUM(NULLIF(vac.new_vaccinations, '')) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinatedRolling
FROM covidFinal.covid_deaths dea
JOIN covidFinal.covid_vaccination vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3;
