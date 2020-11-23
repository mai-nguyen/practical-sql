-- view activities
select distinct activities
from meat_poultry_egg_inspect;

-- create copy with new columns
create table meat_inspect_new as
select *, 
'false'::boolean as meat_processing, 
'false'::boolean as poultry_processing
from meat_poultry_egg_inspect;

-- update columns
update meat_inspect_new
set meat_processing = true where activities ilike '%Meat Processing%';

update meat_inspect_new
set poultry_processing = true where activities ilike '%Poultry Processing%';

-- view results
select meat_processing, poultry_processing, activities
from meat_inspect_new;

select meat_processing, poultry_processing, count(*)
from meat_inspect_new
group by meat_processing, poultry_processing
order by count(*);

-- updating table
ALTER TABLE meat_poultry_egg_inspect RENAME TO meat_poultry_egg_inspect_temp;
ALTER TABLE meat_inspect_new RENAME TO meat_poultry_egg_inspect;
ALTER TABLE meat_poultry_egg_inspect_temp RENAME TO meat_poultry_egg_inspect_backup;