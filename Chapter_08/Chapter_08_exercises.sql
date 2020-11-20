-- Exercise 1: Both the 2014 and 2009 library survey tables contain the columns gpterms (the number of internet-connected computers used by the public) and pitusr (uses of public internet computers per year). Find the percent change in each column over time (by state?).

select max(gpterms), min(gpterms)
from pls_fy2014_pupld14a;
-- max = 4678
-- min = -3


SELECT pls14.stabr,
       sum(pls09.gpterms) AS gpterms09,
	   sum(pls14.gpterms) AS gpterms14,
       round( (CAST(sum(pls14.gpterms) AS decimal(10,1)) - sum(pls09.gpterms)) /
                    sum(pls09.gpterms) * 100, 2 ) AS pct_change_gpterms
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.gpterms >= 0 AND pls09.gpterms >= 0
GROUP BY pls14.stabr
ORDER BY pct_change_gpterms DESC;

select max(pitusr), min(pitusr)
from pls_fy2014_pupld14a;
-- max = 6509882
-- min = -3

SELECT pls14.stabr,
        sum(pls09.pitusr) as pitusr09,
		sum(pls14.pitusr) as pitusr14,        
        round( (CAST(sum(pls14.pitusr) AS decimal(10,1)) - sum(pls09.pitusr)) /
                    sum(pls09.pitusr) * 100, 2 ) AS pct_change_pitusr
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.pitusr >= 0 AND pls09.pitusr >= 0
GROUP BY pls14.stabr
ORDER BY pct_change_pitusr DESC;


-- Exercise 2: Both library survey tables contain a column called obereg, a two-digit Bureau of Economic Analysis Code that classifies each library agency according to a region of the United States, such as New England, Rocky Mountains, and so on. Just as we calculated the percent change in visits grouped by state, do the same to group percent changes in visits by U.S. region using obereg. Consult the survey documentation to find the meaning of each region code. For a bonus challenge, create a table with the obereg code as the primary key and the region name as text, and join it to the summary query to group by the region name rather than the code.
create table oberegs (
	obereg_id varchar(2) constraint obereg_key primary key, 
	region_name varchar(100) NOT NULL
);

CREATE INDEX obereg_idx ON oberegs (obereg_id);

insert into oberegs (obereg_id, region_name)
values 
('01', 'New England (CT ME MA NH RI VT)'),
('02', 'Mid East (DE DC MD NJ NY PA)'),
('03', 'Great Lakes (IL IN MI OH WI)'), 
('04', 'Plains (IA KS MN MO NE ND SD)'),
('05', 'Southeast (AL AR FL GA KY LA MS NC SC TN VA WV)'), 
('06', 'Soutwest (AZ NM OK TX)'),
('07', 'Rocky Mountains (CO ID MT UT WY)'),
('08', 'Far West (AK CA HI NV OR WA)'),
('09', 'Outlying Areas (AS GU MP PR VI)');

/* This code doesn't work bc pls14.obereg has to be in the GROUP BY clause

SELECT pls14.obereg, oberegs.region_name,
       sum(pls09.visits) AS visits_2009,
	   sum(pls14.visits) AS visits_2014,       
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
join oberegs on oberegs.obereg_id = pls14.obereg
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY oberegs.region_name
ORDER BY pct_change DESC;
*/

SELECT oberegs.region_name,
       sum(pls09.visits) AS visits_2009,
	   sum(pls14.visits) AS visits_2014,       
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
join oberegs on oberegs.obereg_id = pls14.obereg
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY oberegs.region_name
ORDER BY pct_change DESC;

-- Exercise 3: Thinking back to the types of joins you learned in Chapter 6, which join type will show you all the rows in both tables, including those without a match? Write such a query and add an IS NULL filter in a WHERE clause to show agencies not included in one or the other table.

select 
pls09.libname as libname09, 
pls14.libname as libname14
from pls_fy2009_pupld09a as pls09 
full outer join pls_fy2014_pupld14a as pls14
on pls14.fscskey = pls09.fscskey
where pls09.fscskey is null or pls14.fscskey is null;