SELECT *
FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

SELECT location , date , total_cases , new_cases , total_deaths , population
FROM PortfolioProject..CovidDeaths
ORDER BY 1 , 2

--Looking at Total Cases vs Total Deaths

SELECT location , date , total_cases ,  total_deaths , (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location = 'United Kingdom'
ORDER BY 2

--Looking at Total Cases vs Population
SELECT location , date , population, total_cases , (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location = 'United Kingdom'

--Looking at Countries with highest infection rate compared to population
SELECT location , population, MAX(total_cases) AS Highest_CaseCount , (MAX(total_cases)/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location , population
ORDER BY 1

--Order Countries by Death Count
SELECT location , MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL 
GROUP BY location
ORDER BY TotalDeathCount DESC

--Order Continents by Death Count
--SELECT location , MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent is NULL 
--GROUP BY location
--ORDER BY TotalDeathCount DESC
SELECT continent , MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

/*GLOBAL Numbers*/
SELECT SUM(new_cases) AS total_cases,  SUM(cast(new_deaths as int)) AS total_deaths , (SUM(cast(new_deaths as int))/SUM(new_cases))*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY continent
ORDER BY 1,2

-- Join the tables on date and location

SELECT TOP 5 *
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.date = vac.date
	AND dea.location = vac.location

/*Looking at Total Population vs Running Total Vaccinations*/
SELECT TOP 5 dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations ,
SUM( CONVERT(int, vac.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location , dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.date = vac.date
	AND dea.location = vac.location
WHERE dea.continent is NOT NULL
ORDER BY 2, 3

-- Rolling Percentage of Population Vaccinated
-- Using CTE

WITH PopvsVac(Continent, Location,  Population, New_Vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent , dea.location , dea.population , vac.new_vaccinations ,SUM( CONVERT(numeric, vac.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location ) AS RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
WHERE dea.continent is NOT NULL
)
SELECT * , (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

-- Rolling Percentage of Population Vaccinated
-- Using Temp Table

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255), 
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent , dea.location , dea.population , vac.new_vaccinations ,SUM( CONVERT(numeric, vac.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location ) AS RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
WHERE dea.continent is NOT NULL

SELECT * , (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- Creating View to store data for later visuals 

CREATE VIEW PercentagePopulationVaccinated AS
SELECT dea.continent , dea.location , dea.population , vac.new_vaccinations ,SUM( CONVERT(numeric, vac.new_vaccinations )) OVER (PARTITION BY dea.location ORDER BY dea.location ) AS RollingPeopleVaccinated 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
WHERE dea.continent is NOT NULL
 