SELECT *
FROM PortfolioProjects.dbo.coviddeaths$
ORDER BY 3,4

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProjects.dbo.coviddeaths$
ORDER BY 1,2

--we shall do total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProjects.dbo.coviddeaths$
WHERE location like '%India%'
ORDER BY 1,2

-- let's look at total cases vs population 
-- shows what % of population got covid
SELECT location,date,population,total_cases,total_deaths,  (total_cases/population)*100 AS PercentagePopulationInfected
FROM PortfolioProjects.dbo.coviddeaths$
WHERE location like '%India%'
ORDER BY 1,2
--highest infection rate country 
SELECT location,population,MAX(total_cases) AS HighestInfection,  MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM PortfolioProjects.dbo.coviddeaths$
--WHERE location like '%India%'
GROUP BY location, population
ORDER BY 1,2

--Countries with high mortality
SELECT location, SUM(CAST(total_deaths as bigint)) AS totaldeathcount
FROM PortfolioProjects.dbo.coviddeaths$
WHERE continent is not null
GROUP BY location
ORDER BY totaldeathcount DESC

--Continent wise break down of high mortality

SELECT continent, SUM(CAST(total_deaths as bigint)) AS totaldeathcount
FROM PortfolioProjects.dbo.coviddeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY totaldeathcount DESC

--  Global numbers
SELECT date,SUM(new_cases) as totalcases, SUM(CAST(new_deaths as bigint)) as totaldeaths, (SUM(CAST(new_deaths as bigint))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProjects.dbo.coviddeaths$
--WHERE location like '%India%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2
-- looking at total popu vs vacci
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location oRDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects.dbo.coviddeaths$ AS dea
JOIN PortfolioProjects.dbo.covidvaccinations$ AS vac ON dea.location=vac.location AND dea.date=vac.date
WHEre dea.continent is not null
ORDER BY 2,3
-- USing CTE
WITH PopvsVac(Continent, location, date, population,new_vaccinations, RollingPeopleVaccinated) AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location oRDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects.dbo.coviddeaths$ AS dea
JOIN PortfolioProjects.dbo.covidvaccinations$ AS vac ON dea.location=vac.location AND dea.date=vac.date
WHEre dea.continent is not null
--ORDER BY 2,3
)
SELECT * , (RollingPeopleVaccinated/population)*100
FROM PopvsVac

--creating view for date vizz
Create view PercentPeopleVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location oRDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjects.dbo.coviddeaths$ AS dea
JOIN PortfolioProjects.dbo.covidvaccinations$ AS vac ON dea.location=vac.location AND dea.date=vac.date
WHEre dea.continent is not null
--ORDER BY 2,3

--huh
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProjects.dbo.coviddeaths$
--Where location like '%India%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProjects.dbo.coviddeaths$
--Where location like '%India%'
Where continent is null 
and location not in ('World', 'European Union', 'International') AND location not like '%income%'
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjects.dbo.coviddeaths$
--Where location like '%India%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjects.dbo.coviddeaths$
--Where location like '%India%'
Group by Location, Population, date
order by PercentPopulationInfected desc