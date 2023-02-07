
create table covid_deaths
(
iso_code	varchar(100),
continent	varchar(100),
location	 varchar(100),
date	varchar(100),
population	varchar(100),
total_cases	varchar(100),
new_cases	varchar(100),
new_cases_smoothed	varchar(100),
total_deaths	varchar(100),
new_deaths	varchar(100),
new_deaths_smoothed	varchar(100),
total_cases_per_million	varchar(100),
new_cases_per_million	varchar(100),
new_cases_smoothed_per_million	varchar(100),
total_deaths_per_million	varchar(100),
new_deaths_per_million	varchar(100),
new_deaths_smoothed_per_million	varchar(100),
reproduction_rate	varchar(100),
icu_patients	varchar(100),
icu_patients_per_million	varchar(100),
hosp_patients	varchar(100),
hosp_patients_per_million	varchar(100),
weekly_icu_admissions	varchar(100),
weekly_icu_admissions_per_million	varchar(100),
weekly_hosp_admissions	varchar(100),
weekly_hosp_admissions_per_million varchar(100)

);


LOAD DATA INFILE 'D:\\rupam\\Covid_deaths.csv'
 INTO TABLE covid_deaths 
 FIELDS TERMINATED BY ','
 ENCLOSED BY '"'
 LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

/*CHANGE THE DATATYPE OF DATE*/

ALTER TABLE COVID_DEATHS
ADD COLUMN NEW_DATE date AFTER DATE
delete  new_date from covid_deaths

UPDATE COVID_DEATHS
SET NEW_DATE = str_to_date(`date`,'%d-%m-%Y')

Q.1 TOTAL CASES VS TOTAL DEATHS in india
-- it shows likelihood of dying if you catch covid
select location,new_date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathPercentage
from covid_deaths
where location like'india' and continent <> ''
order by  1,2

select * from covid_deaths
where continent <> ''limit 5

SELECT * FROM COVID_DEATHS

Q.2 TOTAL CASES VS TOTAL POPULATION
 //Shows percentage of population got covid

select location,new_date,total_cases, population, total_cases/population *100 as PopulationInfected
from COVID_DEATHS
where continent <> '' limit 10000

/*Changing the data type of total cases and population*/
alter table covid_deaths
modify column total_cases int

alter table covid_deaths
modify column population int

alter table covid_deaths
modify column total_deaths int


Q.3 WHICH COUNTRIES HAS THE HIGHEST INFECTION RATE COMPARED TO POPULATION

select location, population ,MAX(total_cases) as HIGHEST_INFECTION_count , MAX(total_cases/population *100) as HIGHEST_INFECTION_RATE
from COVID_DEATHS
where continent <> ''
group by 1,2
order by HIGHEST_INFECTION_RATE desc

Q.4 COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

select location, population ,MAX(total_deaths) as HIGHEST_DEATH_COUNT , MAX(total_deaths/population *100) as HIGHEST_DEATH_RATE
from COVID_DEATHS
where continent <> ''
group by 1,2
order by HIGHEST_DEATH_COUNT desc

Q.5 SHOWING CONTINENT WITH THE HIGHEST DEATH COUNT

select CONTINENT ,MAX(total_deaths) as HIGHEST_DEATH_COUNT
from COVID_DEATHS
where continent <> ''
group by 1
order by HIGHEST_DEATH_COUNT desc

Q.6 TOTAL NUMBER OF new CASES EACH DAY AND new DEATH accross the world

select date, sum(new_cases) as TotalCase,sum(new_deaths) as Total_Death, sum(new_deaths)/sum(new_cases) *100 as deathPercentage
from covid_deaths
group by date

Q.7 TOTAL NO OF CASES, DEATH AND DEATHPERCENTAGE IN ENTIRE WORLD
select sum(new_cases) as TotalCase,sum(new_deaths) as Total_Death, sum(new_deaths)/sum(new_cases) *100 as deathPercentage
from covid_deaths

/Changing datatype/
alter table covid_deaths
modify column new_deaths int

SELECT * FROM COVID_VACCINATION

/*JOINING BOTH TABLE ON LOCATION AND DATE*/

SELECT *
FROM COVID_DEATHS cd
JOIN COVID_VACCINATION cv ON cd.LOCATION = cv.LOCATION AND cv.DATE = cd.DATE

Q.8 TOTAL POPULATION vs  NEW VACCINATion
 
with cte  as
(
SELECT cd.new_date,cd.CONTINENT,cd.LOCATION, cd.POPULATION,cv.new_vaccinations,
sum(new_vaccinations) over(partition by cd.location order by cd.location,cd.new_date ) AS CountofpeopleVaccinated
FROM COVID_DEATHS cd
JOIN COVID_VACCINATION cv ON cd.LOCATION = cv.LOCATION AND cv.DATE = cd.DATE
where cd.continent <> '')

select continent,LOCATION,new_vaccinations,POPULATION,(CountofpeopleVaccinated/population)*100 as VaccinationPerPopulationRate
from cte 


CREATING VIEW

Create view PercentPopulationVaccinated
as
SELECT cd.new_date,cd.CONTINENT,cd.LOCATION, cd.POPULATION,cv.new_vaccinations,
sum(new_vaccinations) over(partition by cd.location order by cd.location,cd.new_date ) AS CountofpeopleVaccinated
FROM COVID_DEATHS cd
JOIN COVID_VACCINATION cv ON cd.LOCATION = cv.LOCATION AND cv.DATE = cd.DATE
where cd.continent <> ''

select * from PercentPopulationVaccinated

/CHANGE THE DATETYPE IN THE COVID_VAC TABLE/

ALTER TABLE COVID_VACCINATION
ADD COLUMN NEW_DATE DATE AFTER DATE

UPDATE COVID_VACCINATION
SET NEW_DATE = STR_TO_DATE(DATE,'%d-%m-%y')

ALTER TABLE COVID_VACCINATION
MODIFY COLUMN NEW_VACCINATIONS INT

select * from covid_vaccination