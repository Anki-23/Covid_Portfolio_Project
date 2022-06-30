


select *
from PortfolioProject..CovidDeaths
where continent is NULL



--select *
--from PortfolioProject..CovidVaccinations

--order by 3, 4

--Deathpercent in India


select location, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercent
from PortfolioProject..CovidDeaths
where location = 'India'

order by 1,2


---total cases vs population
select location, date, total_cases, new_cases, total_deaths, population, (total_deaths/population)*100 as DeathPercent
from PortfolioProject..CovidDeaths
where location = 'India'

order by DeathPercent  desc

-- country which has highest infection rate to population ratio
select location, max(total_cases) as hinfectcount,  max((total_cases/population))*100 as peoplepercentinfect
from PortfolioProject..CovidDeaths
group by location
order by peoplepercentinfect desc


--country with highest deathcount wrt population
select continent, sum(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths
--where location= 'India'
where continent is not null
group by continent
order by totaldeathcount desc


---showing continents with the highest death count per population
select continent, max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc



--Global Numbers

select location, date, total_cases, total_deaths, population, --(total_deaths/total_cases) as DeathPercent
from PortfolioProject..CovidDeaths
--where location = 'India'
where continent is not null


select  sum(new_cases) as totalnewcases, sum(cast(new_deaths as int)) as total_new_deaths, 
(sum(cast(new_deaths as int))/sum(new_cases)) as DeathPercentage
from PortfolioProject..CovidDeaths
--where location = 'India'
where continent is not null
--group by date
order by DeathPercentage desc


--Total Population vs Vaccinations

select vac.continent, vac.location, dea.date, dea.population, vac.new_vaccinations, 
sum( cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location , dea.date) total_vacc
from  PortfolioProject..CovidVaccinations vac
join  PortfolioProject..CovidDeaths dea on vac.location= dea.location
and vac.date= dea.date
where vac.continent is not null and vac.location  like 'Indi%'
--group by vac.location, vac.continent


--USe CTE


with cte( continent, location, date,population, new_vaccinations, total_vacc)
as
(	
select vac.continent, vac.location, dea.date, dea.population, vac.new_vaccinations, 
sum( cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location , dea.date) total_vacc
from  PortfolioProject..CovidVaccinations vac
join  PortfolioProject..CovidDeaths dea on vac.location= dea.location
and vac.date= dea.date
where vac.continent is not null and vac.location  like 'Indi%'
--group by vac.location, vac.continent
)
select * , (population-total_vacc ) as diff
from cte


--use temp table
drop table if exists #popvacc
create table #popvacc
(
continent nvarchar(255), location nvarchar(255), date datetime, population	float, new_vaccinations nvarchar(255), total_vacc numeric
)

insert into #popvacc
	
select vac.continent, vac.location, dea.date, dea.population, vac.new_vaccinations, 
sum( cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location , dea.date) total_vacc
from  PortfolioProject..CovidVaccinations vac
join  PortfolioProject..CovidDeaths dea on vac.location= dea.location
and vac.date= dea.date
where vac.continent is not null and vac.location  like 'Indi%'
--group by vac.location, vac.continent


select * , (population-total_vacc ) as diff
from #popvacc



--Create View to store data
create view percentvacc as
select vac.continent, vac.location, dea.date, dea.population, vac.new_vaccinations, 
sum( cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location , dea.date) total_vacc
from  PortfolioProject..CovidVaccinations vac
join  PortfolioProject..CovidDeaths dea on vac.location= dea.location
and vac.date= dea.date
where vac.continent is not null and vac.location  like 'Indi%'
--group by vac.location, vac.continent

select * from percentvacc