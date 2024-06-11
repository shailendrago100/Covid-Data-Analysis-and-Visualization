SELECT * FROM covid_data.coviddeaths;

select count(new_tests_smoothed) from covid_data.covidvaccinations where new_tests is null or new_tests = '';

desc covid_data.coviddeaths;

ALTER TABLE covid_data.coviddeaths MODIFY date date;

update covid_data.coviddeaths set date = str_to_date(concat(SUBSTRING_INDEX(date, '/', 1),',',SUBSTRING_INDEX(SUBSTRING_INDEX(date,'/',2),'/',-1),',',SUBSTRING_INDEX(date, '/', -1)), '%m,%d,%Y');