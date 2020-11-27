-- 1. Revise the code in Listing 12-15 to dig deeper into the nuances of Waikiki’s high temperatures. Limit the temps_collapsed table to the Waikiki maximum daily temperature observations. Then use the WHEN clauses in the CASE statement to reclassify the temperatures into seven groups that would result in the following text output:

-- '90 or more'
-- '88-89'
-- '86-87'
-- '84-85'
-- '82-83'
-- '80-81'
-- '79 or less'

-- In which of those groups does Waikiki’s daily maximum temperature fall most often?

WITH temps_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
           CASE WHEN max_temp >= 90 THEN '90 or more'
                WHEN max_temp BETWEEN 88 AND 89 THEN '88-89'
                WHEN max_temp BETWEEN 86 AND 87 THEN '86-87'
                WHEN max_temp BETWEEN 84 AND 85 THEN '84-85'
                WHEN max_temp BETWEEN 82 AND 83 THEN '82-83'
					 			WHEN max_temp BETWEEN 80 AND 81 THEN '80-81'
                ELSE '79 or less'
            END
    FROM temperature_readings
	where station_name ilike 'Waikiki%')

SELECT station_name, max_temperature_group, count(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY count(*) DESC;

-- 2. Revise the ice cream survey crosstab in Listing 12-11 to flip the table. In other words, make flavor the rows and office the columns. Which elements of the query do you need to change? Are the counts different?

select *
from crosstab (
	'select flavor, office, count(*)
	from ice_cream_survey
	group by flavor, office
	order by flavor',
	
	'select office
	from ice_cream_survey
	group by office
	order by office'
			  )

as
(flavor varchar(20),
downtown bigint,
midtown bigint,
uptown bigint)