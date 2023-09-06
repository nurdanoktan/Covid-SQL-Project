-- Section 1: Initial Data Retrieval
-- Retrieve the initial data from CovidDeaths and CovidVaccinations tables, filtering out records where the continent is not specified.

SELECT *
FROM PortfolioProjectSQL..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

SELECT *
FROM PortfolioProjectSQL..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3, 4;

-- Section 2: Data Selection
-- Select data that we are going to be using for analysis.

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjectSQL..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Section 3: Percentage of Cases and Deaths in Portugal
-- Calculate and display the percentage of COVID-19 cases that resulted in death in Portugal over time.

SELECT Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS DeathPercentage
FROM PortfolioProjectSQL..CovidDeaths
WHERE Location LIKE '%portugal%' AND continent IS NOT NULL
ORDER BY 1, 2;

-- Section 4: Percentage of Population Infected in Portugal
-- Calculate and display the percentage of the population in Portugal that has been infected with COVID-19 over time.

SELECT Location, date, population, total_cases, (total_cases / population) * 100 AS PercentagePopulationInfected
FROM PortfolioProjectSQL..CovidDeaths
WHERE Location LIKE '%portugal%'
ORDER BY 1, 2;

-- Section 5: Countries with Highest Infection Rates
-- Identify countries with the highest infection rates compared to their population and display relevant statistics.

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases / population)) * 100 AS PercentagePopulationInfected
FROM PortfolioProjectSQL..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY population, Location
ORDER BY PercentagePopulationInfected DESC;

-- Section 6: Countries with Highest Death Counts
-- Identify countries with the highest death counts and display the total death count for each country.

SELECT Location, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProjectSQL..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

-- Section 7: Continents with Highest Death Counts
-- Identify continents with the highest death counts and display the total death count for each continent.

SELECT continent, MAX(CAST(Total_deaths AS INT)) AS TotalDeathCount
FROM PortfolioProjectSQL..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Section 8: Global COVID-19 Numbers
-- Calculate and display global COVID-19 statistics, including total cases, total deaths, and death percentage.

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathPercentage
FROM PortfolioProjectSQL..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Section 9: Total Population vs Vaccinations Using CTE
-- Calculate rolling people vaccinated over time using a Common Table Expression (CTE).

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
           SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
    FROM PortfolioProjectSQL..CovidDeaths dea
    JOIN PortfolioProjectSQL..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated / Population) * 100
FROM PopvsVac;

-- Section 10: Total Population vs Vaccinations Using Temp Table
-- Calculate rolling people vaccinated over time using a temporary table.

DROP TABLE IF EXISTS #PercentPopulationVaccinated;
CREATE TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_Vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjectSQL..CovidDeaths dea
JOIN PortfolioProjectSQL..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date;

SELECT *, (RollingPeopleVaccinated / Population) * 100
FROM #PercentPopulationVaccinated;

-- Section 11: Creating a View for Data Visualization
-- First: Drop the existing view if it exists.
IF OBJECT_ID('PercentPopulationVaccinated', 'V') IS NOT NULL
BEGIN
    DROP VIEW PercentPopulationVaccinated;
END

-- Then: Create a view to store data for later visualizations.
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProjectSQL..CovidDeaths dea
JOIN PortfolioProjectSQL..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


-- Section 12: Final Data Output
-- Retrieve data from the view for data visualization.

SELECT *
FROM PercentPopulationVaccinated;
