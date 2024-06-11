select * from covid_data.coviddeaths;
 
select * from covid_data.covidvaccinations;

-- selecting the total number of cases and total number of deaths, with death percentage 
-- The query is saved as 1_table.csv  
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage 
from covid_data.coviddeaths where continent <> '';

-- selecting the total death count in each continent.  
-- The query is saved as 2_table.csv  
select continent as location, sum(new_deaths) as TotalDeathCount from covid_data.coviddeaths 
where continent <> '' group by continent order by TotalDeathCount desc;

-- selecting the percentage of population infected of covid from the entire population, for each location. 
-- The query is saved as 3_table.csv  
select location, population, max(total_cases) as HighestInfectionCount,
 max(total_cases/population)*100 as PercentPopulationInfected  
 from covid_data.coviddeaths where continent <> '' group by location, population
 order by PercentPopulationInfected desc;
 
 -- selecting the person infected count by date for each location. 
 -- The query is saved as 4_table.csv  
 select location, population, date, max(total_cases) as HighestInfectionCount,
 max(total_cases/population)*100 as PercentPopulationInfected  
 from covid_data.coviddeaths where continent <> '' group by location, population,date
 order by PercentPopulationInfected desc;



