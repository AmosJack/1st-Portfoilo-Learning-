Select *
from PortfolloProject..coviddeath
where continent is not null
order by 3,4



-- Select *
--from PortfolloProject..covidvaccinations
--order by 3,4

-- Select Data that we are gping to be using

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolloProject..coviddeath
where continent is not null
order by 1,2


--Looking at Total cases vs Total Deaths 
-- Shows the likelyhood of dying from Covid in your Country
Select location, date, total_cases, total_deaths, (CONVERT(int, total_deaths/total_cases))*100 as DeathPercentage
From PortfolloProject..coviddeath
where location like '%states%'
and continent is not null
order by 1,2


-- Looking total cases vs population
--shows % of population with Covid
Select location, date, population, total_cases,(total_cases/population)*100 as PercentageInfected
From PortfolloProject..coviddeath
--where location like '%states%'
order by 1,2


-- Looking at Countries with Highest rate compared to population
Select location, population, MAX(total_cases) as Highestinfectionscount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolloProject..coviddeath
--where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select Location, MAX(total_deaths) as TotalDeathCount
From PortfolloProject..coviddeath
--where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc


--BREAKING THINGS DOWN BY CONTINENT 

--Showing continent with the highest death count per population


Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolloProject..coviddeath
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- continet with highest death 
Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolloProject..coviddeath
--where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global Numbers 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage --total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolloProject..coviddeath
--where location like '%nigeria%'
Where continent is not null
--Group By date
order by 1,2

-- Global Numbers 
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths1, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage --total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolloProject..coviddeath
--where location like '%nigeria%'
Where continent is not null
--Group By date
order by 1,2



Select *
from PortfolloProject..covidvaccinations
--where continent is not null
order by 3,4

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolloProject..coviddeath dea
Join PortfolloProject ..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3	

-- USE CTE
with popvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolloProject..coviddeath dea
Join PortfolloProject ..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

select *, (RollingPeopleVaccinated/population)*100
from popvac

--TEM TABLE 
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolloProject..coviddeath dea
Join PortfolloProject ..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


-- Creating View to store data for later visualization

Create View PercentPopulationVaccinated as
Select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolloProject..coviddeath dea
Join PortfolloProject ..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

