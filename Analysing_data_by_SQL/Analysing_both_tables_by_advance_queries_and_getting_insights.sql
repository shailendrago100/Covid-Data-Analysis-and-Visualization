select * from covid_data.coviddeaths order by 3,4;

select * from covid_data.covidvaccinations order by 3, 4;

-- Selecting the data that we are going to use  
select  location, date, total_cases, new_cases, total_deaths, population from covid_data.coviddeaths order by location, date;

-- Total cases vs total deaths 
select  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage from 
covid_data.coviddeaths order by location, date;
 
 select  location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage from 
covid_data.coviddeaths where location like '%states%' order by location, date;


-- total cases vs population  
 select  location, date, total_cases, population, (total_cases/population)*100 as PercentPolulationInfected from 
covid_data.coviddeaths where location like '%states%' order by location, date;

-- Looking at countries with highest infection rate compared to population 
select location, population, max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as 
PercentPolulationInfected from covid_data.coviddeaths group by location, population
order by PercentPolulationInfected desc;

-- Death count and its percent per population of a country.  
select location, sum(total_deaths) as totalDeathCount
 from covid_data.coviddeaths group by location order by totalDeathCount desc;
 
 -- After running the above query, we found that name of continents are also given in the location like world, asia etc. 
 -- At this point the name of continent field is null or empty. So, we need to always add "continent is not null". 
 
 select location, sum(total_deaths) as totalDeathCount
 from covid_data.coviddeaths where continent <> '' group by location order by totalDeathCount desc;
 
select continent, sum(total_deaths) as totalDeathCount
 from covid_data.coviddeaths where continent <> '' group by continent order by totalDeathCount desc;
 
 select location, sum(total_deaths) as totalDeathCount
 from covid_data.coviddeaths where continent = '' group by location order by totalDeathCount desc;
 
 -- number of new cases and new deaths at each date 
 select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
 (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage from covid_data.coviddeaths
 where continent <> '' group by location order by date asc, DeathPercentage desc;
 
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths,
 (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage from covid_data.coviddeaths
 where continent <> '';
 
 -- Joining coviddeaths and covidvaccinations 
 select * from covid_data.coviddeaths dea join covid_data.covidvaccinations vac
 on dea.location = vac.location and dea.date = vac.date;
 
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.location order by dea.location asc, dea.date asc)
 as RollingPeopleVaccinated
 from covid_data.coviddeaths dea join covid_data.covidvaccinations vac 
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent <> '' order by location asc, date asc;

-- We cannot access directly RollingPeopleVaccinated while printing it. 
-- to solve this issue we can use the concept of cte 
with PopVsVac (continent, location, date, population,new_vaccinations, RollingPeopleVaccinated)
as 
(
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.location order by dea.location asc, dea.date asc)
 as RollingPeopleVaccinated
 from covid_data.coviddeaths dea join covid_data.covidvaccinations vac 
 on dea.location = vac.location and dea.date = vac.date
 where dea.continent <> ''
 -- order by location asc, date asc;
 )
select *, (RollingPeopleVaccinated/Population)*100 from PopVsVac;

-- to resolve the same issue we can also create a temporary table 
drop table if exists PercentPopulationVaccinated;
create table PercentPopulationVaccinated
(
continent text,
location text,
date date,
population int,
new_vaccinations int,
RollingPeopleVaccinated int 
);

insert into PercentPopulationVaccinated
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.location order by dea.location asc, dea.date asc)
 as RollingPeopleVaccinated
 from covid_data.coviddeaths dea join covid_data.covidvaccinations vac 
 on dea.location = vac.location and dea.date = vac.date;
 -- where dea.continent <> ''
 -- order by location asc, date asc;
select *, (RollingPeopleVaccinated/Population)*100 from PercentPopulationVaccinated;

 
 -- Creating Views
 Create view PercentPoopulationVaccinated as
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(vac.new_vaccinations) over (partition by dea.location order by dea.location asc, dea.date asc)
 as RollingPeopleVaccinated
 from covid_data.coviddeaths dea join covid_data.covidvaccinations vac 
 on dea.location = vac.location and dea.date = vac.date;
 -- where dea.continent <> ''
 -- order by location asc, date asc;
 

