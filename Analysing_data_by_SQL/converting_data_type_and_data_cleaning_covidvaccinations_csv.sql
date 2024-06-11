SELECT * FROM covid_data.covidvaccinations;

select count(new_tests_smoothed) from covid_data.covidvaccinations where new_tests is null or new_tests = '';

desc covid_data.covidvaccinations;

ALTER TABLE covid_data.covidvaccinations MODIFY new_tests int;

update covid_data.covidvaccinations set date = str_to_date(concat(SUBSTRING_INDEX(date, '/', 1),',',SUBSTRING_INDEX(SUBSTRING_INDEX(date,'/',2),'/',-1),',',SUBSTRING_INDEX(date, '/', -1)), '%m,%d,%Y');
