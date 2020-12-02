
-- 1. The style guide of a publishing company you’re writing for wants you to avoid commas before suffixes in names. But there are several names like Alvarez, Jr. and Williams, Sr. in your database. Which functions can you use to remove the comma? Would a regular expression function help? How would you capture just the suffixes to place them into a separate column?

create table names_with_suffix(
	last_name_suffix varchar(100)
);

insert into names_with_suffix(last_name_suffix)
values 
('Alvarez, Jr.'),
('Williams, Sr.');

select 
last_name_suffix,
(regexp_split_to_array(last_name_suffix, ', '))[1] as last_name, 
(regexp_split_to_array(last_name_suffix, ', '))[2] as suffix
from names_with_suffix;

-- 2. Using any one of the State of the Union addresses, count the number of
-- unique words that are five characters or more. Hint: you can use
-- regexp_split_to_table() in a subquery to create a table of words to count.
-- Bonus: remove commas and periods at the end of each word.

-- Answer:


-- First attempt
-- unique words with counts table
select regexp_split_to_table(speech_text, ' ') as word, count(*)

from
	(select *
	from president_speeches
	where sotu_id = 20) as one_speech

group by word
order by count(*) desc;


-- unique words with commas, periods removed and characters counter
select 
(regexp_match(word, '(\w+).*'))[1], -- remove commas, periods at end and extract text from array
counts
from
	(select regexp_split_to_table(speech_text, ' ') as word, count(*) counts

	from
		(select *
		from president_speeches
		where sotu_id = 20) as one_speech

	group by word
	order by count(*) desc) as word_count

where char_length((regexp_match(word, '(\w+).*'))[1]) >= 5;

-- Second attempt, adapted from solution
with 
	word_list (word)
as 
	(select regexp_split_to_table(speech_text, '\s') as word
	 from president_speeches
	 where speech_date = '1949-01-05'	
	)

select lower((regexp_match(word, '(\w+).*'))[1]) as cleaned_word, count(*) as counts
from word_list
where length((regexp_match(word, '(\w+).*'))[1]) >= 5
group by cleaned_word
order by counts desc;


-- Third attempt, with variable input being the soto_id only
-- this is to manually view the word frequencies each time
with 
	word_list (word, speech_date)
as 
	(select regexp_split_to_table(speech_text, '\s') as word, speech_date
	 from president_speeches
	 where sotu_id = 1
	)

select 
	lower((regexp_match(word, '(\w+).*'))[1]) as cleaned_word, 
	count(*) as counts,
	speech_date
from word_list
where length((regexp_match(word, '(\w+).*'))[1]) >= 5
group by cleaned_word, speech_date
order by counts desc;


-- 3. 

SELECT president,
       speech_date,
       ts_rank(search_speech_text, to_tsquery('war & security & threat & enemy')) AS rank_score,
	   ts_rank_cd(search_speech_text, to_tsquery('war & security & threat & enemy')) AS rank_cd_score,
	   rank() over (order by ts_rank_cd(search_speech_text, to_tsquery('war & security & threat & enemy')))
			   
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('war & security & threat & enemy')
ORDER BY rank_score DESC
--LIMIT 5
;
