
 SELECT * 
 FROM CovidDeaths
 WHERE continent IS NOT NULL


SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS float)/CAST(total_cases AS float))*100 AS Death_Percentage
FROM CovidDeaths
WHERE location LIKE 'India'
 AND continent IS NOT NULL
ORDER BY 1,2

--Looking at Total Cases vs Popuation
--Shows What Percentage of Population Got Covid
SELECT location, date,population, total_cases, (CAST(total_cases AS float)/CAST(population AS float))*100 AS Covid_Infected
FROM CovidDeaths 
WHERE continent IS NOT NULL
ORDER BY 1,2

--Looking at Contries with Highest Infection Rate compared to Populaion
SELECT location,population, MAX(total_cases) AS Highest_Infestion, MAX((CAST(total_cases AS float)/CAST(population AS float))*100) AS Percet_Popolaion_Infected
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY 4 DESC



--Looking at Contries with Highest Death Count per Populaion
SELECT location, MAX(total_deaths) AS Total_DeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC


--Looking at Continent with Highest Death Count per Populaion
SELECT continent, MAX(total_deaths) AS Total_DeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY 2 DESC


-- Global Number
SELECT  date, SUM(new_cases) AS Total_Caese , SUM(CAST(new_deaths as int)) AS Total_Death , 
SUM(CAST(total_deaths AS float)) / SUM(CAST(new_cases AS float)) AS Death_Percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- Lokking at Total Popolation and Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.date ) 
AS Rolling_Pepole_Vaccinatios
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


--CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, Rolling_Pepole_Vaccinatios)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.date ) 
AS Rolling_Pepole_Vaccinatios
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *,(Rolling_Pepole_Vaccinatios/population)*100
FROM PopvsVac



--TEMP Table
DROP TABLE IF EXISTS #Percent_Popolation_Vaccinated
CREATE TABLE #Percent_Popolation_Vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_Pepole_Vaccinatios numeric
)
INSERT INTO #Percent_Popolation_Vaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.date ) 
AS Rolling_Pepole_Vaccinatios
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *,(Rolling_Pepole_Vaccinatios/population)*100
FROM #Percent_Popolation_Vaccinated




--CRATING VIEW
CREATE VIEW Percent_Popolation_Vaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location Order by dea.date ) 
AS Rolling_Pepole_Vaccinatios
FROM CovidDeaths dea
JOIN CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL



