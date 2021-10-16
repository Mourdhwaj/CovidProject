SELECT * FROM PortfolioProject1. .covidDeaths
where continent is not null 
order by 3,4;
--SELECT * FROM PortfolioProject1. .covidVaccination
--order by 3,4;
 SELECT LOCATION,DATE,POPULATION,NEW_CASES, TOTAL_DEATHS FROM PortfolioProject1. . ORDER BY 1,2;
  SELECT LOCATION,DATE,POPULATION,total_cases, TOTAL_DEATHS FROM PortfolioProject1. .covidDeaths ORDER BY 1,2;
  --looking at total cases vs total deaths
  
  select location ,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
  FROM PortfolioProject1. .covidDeaths 
   ORDER BY 1,2;

  select location ,date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
  FROM PortfolioProject1. .covidDeaths 
  where location like 'india%' and  continent is not null 
  ORDER BY 1,2;

  --Looking at total_cases vs  Population
  --Shows Positivity_ratios 
  select location ,date, population, new_cases, (new_cases/population)*100 as  Positivity_ratio 
  FROM PortfolioProject1. .covidDeaths 
 -- where location like 'india%' 
 where    continent is not null 
  ORDER BY 1,2;

  --Shows Positivity_ratio in India 
  select location ,date, population, new_cases, (new_cases/population)*100 as  Positivity_ratio 
  FROM PortfolioProject1. .covidDeaths 
 where location like 'india%' 
  ORDER BY 1,2;

   --Countries with highest infection rate 

  select location ,population, max(total_cases)as HighestInfectionCount, max((total_cases/population)) *100 as PercentagePopulationInfected 
  FROM PortfolioProject1. .covidDeaths 
  --where location like 'india%' 
group by location,population
 ORDER BY PercentagePopulationInfected desc;
  
  -- Countries with Highest Death Count per Population

  select location ,MAX(cast(total_deaths as int)) as TotalDeathCount 
  FROM PortfolioProject1. .covidDeaths 
  --where location like 'india%' 
  where continent is not null 
group by location
 ORDER BY TotalDeathCount desc;

 --Let's break things down by Continents

 select continent ,MAX(cast(total_deaths as int)) as TotalDeathCount 
  FROM PortfolioProject1. .covidDeaths 
  --where location like 'india%' 
  where continent is not null 
group by continent
 ORDER BY TotalDeathCount desc;

  select location ,MAX(cast(total_deaths as int)) as TotalDeathCount 
  FROM PortfolioProject1. .covidDeaths 
  --where location like 'india%' 
  where continent is  null 
group by location
 ORDER BY TotalDeathCount desc;

 --Showing continent with Highest Death Count per Population

  select continent  ,MAX(cast(total_deaths as int)) as TotalDeathCount 
  FROM PortfolioProject1. .covidDeaths 
  --where location like 'india%' 
  where continent is not null 
group by continent
 ORDER BY TotalDeathCount desc;


 --GLOBAL NUMBERS
  select date, SUM(NEW_CASES)AS total_cases, SUM(CAST(NEW_DEATHS AS INT)) AS total_deaths, 
 SUM(CAST(NEW_DEATHS AS INT))/ SUM(NEW_CASES)*100 as DeathPercentage 
  FROM PortfolioProject1. .covidDeaths 
 -- where location like 'india%' and 
 WHERE continent is not null 
 GROUP BY DATE
  ORDER BY 1,2;


  select  SUM(NEW_CASES)AS total_cases, SUM(CAST(NEW_DEATHS AS INT)) AS total_deaths, 
 SUM(CAST(NEW_DEATHS AS INT))/ SUM(NEW_CASES)*100 as DeathPercentage 
  FROM PortfolioProject1. .covidDeaths 
 -- where location like 'india%' and 
 WHERE continent is not null 
 --GROUP BY DATE
  ORDER BY 1,2;

  --Joining Two Tables
  SELECT *
 FROM PortfolioProject1. .covidDeaths dea
 join PortfolioProject1. .covidVaccination vac
 on dea.location= vac.location
 and  dea.date= vac.date;


 -- Looking at Total Population vs Vaccination
 SELECT dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations
 FROM PortfolioProject1. .covidDeaths dea
 join PortfolioProject1. .covidVaccination vac
 on dea.location= vac.location
 and  dea.date= vac.date
 WHERE dea.continent is not null 
  ORDER BY 2,3;

  SELECT dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as cumulativePeopleVaccination
 FROM PortfolioProject1. .covidDeaths dea
 join PortfolioProject1. .covidVaccination vac
 on dea.location= vac.location
 and  dea.date= vac.date
 WHERE dea.continent is not null 
  ORDER BY 2,3;

  --USING CTE

  with PopvsVac(continent,location , Date, Population, new_vaccinations, cumulativePeopleVaccination)
  as

  ( SELECT dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as cumulativePeopleVaccination
 FROM PortfolioProject1. .covidDeaths dea
 join PortfolioProject1. .covidVaccination vac
 on dea.location= vac.location
 and  dea.date= vac.date
 WHERE dea.continent is not null )
  select *, ( cumulativePeopleVaccination/population)*100 as PercentageVaccinated
  from PopvsVac


  --TEMP TABLES 
  create table #PercentagePopulationVaccinated
  (
  Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_Vaccinations numeric,
  cumulativePeopleVaccination numeric)

  insert into #PercentagePopulationVaccinated

  SELECT dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as cumulativePeopleVaccination
 FROM PortfolioProject1. .covidDeaths dea
 join PortfolioProject1. .covidVaccination vac
 on dea.location= vac.location
 and  dea.date= vac.date
 WHERE dea.continent is not null 

  select *, ( cumulativePeopleVaccination/population)*100 as PercentageVaccinated
  from #PercentagePopulationVaccinated

  --Creating View to store data for later visualtisations

  create view PercentagePopulationVaccinated1 as
  SELECT dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
  sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as cumulativePeopleVaccination
 FROM PortfolioProject1. .covidDeaths dea
 join PortfolioProject1. .covidVaccination vac
 on dea.location= vac.location
 and  dea.date= vac.date
 WHERE dea.continent is not null 
 --order by 2,3;
 select *from  PercentagePopulationVaccinated1