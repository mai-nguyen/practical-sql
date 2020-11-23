-- 1. In Listing 10-2, the correlation coefficient, or r value, of the variables pct_bachelors_higher and median_hh_income was about .68. Write a query using the same data set to show the correlation between pct_masters_higher and median_hh_income. Is the r value higher or lower? What might explain the difference?

select
round(corr(pct_masters_higher, median_hh_income)::numeric, 3),
round(regr_r2(pct_masters_higher, median_hh_income)::numeric, 3)
from acs_2011_2015_stats;
-- corr = .568
-- r2 = .323

-- 2. In the FBI crime data, which cities with a population of 500,000 or more have the highest rates of motor vehicle thefts (column motor_vehicle_theft)? Which have the highest violent crime rates (column violent_crime)?

select
st,
city,
population,
round(motor_vehicle_theft::numeric/population * 1000, 2) as pct_motor_theft
from fbi_crime_data_2015
where population > 500000
order by pct_motor_theft desc;

select
st,
city,
population,
round(violent_crime::numeric/population * 1000, 2) as pct_violent_crime
from fbi_crime_data_2015
where population > 500000
order by pct_violent_crime desc;

-- 3. As a bonus challenge, revisit the libraries data in the table pls_fy2014_pupld14a in Chapter 8. Rank library agencies based on the rate of visits per 1,000 population (column popu_lsa), and limit the query to agencies serving 250,000 people or more.

select stabr, libname, address, city, popu_lsa, visits,
round(visits::numeric/popu_lsa * 1000, 2) as visit_rates
from pls_fy2014_pupld14a
where popu_lsa > 250000
order by visit_rates desc;