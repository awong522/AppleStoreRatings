create table appleStore_description_combined as
select * from appleStore_description1
 UNION ALL
 select * from appleStore_description2
 UNION ALL
 select * from appleStore_description3
 UNION ALL
 select * from appleStore_description4
 
 
 **EXPLORATORY DATA ANALYSIS**
 
 --Check number of unique apps in both tablesAppleStore
 
 select count(district id) as uniqueAppIDs
 from AppleStore
 
 select count(district id) as UniqueAppIDs
 From appleStore_description_combined
 
 --Check for any missing values in key fields
 
 Select count(*) as MissingValues
 From AppleStore
 where track_name is null or user_rating is null or prime_genre is null
 
 select count(*) as MissingValues
 from appleStore_description_combined
 where app_desc is null
 
 --Find out the number of apps per genre
 
 select prime_genre, count(*) as NumApps
 from AppleStore
 group by prime genre
 order by NumApps DESC
 
 --Get an overview of the apps ratings
 
 Select min(user_rating) as MinRating,
		max(user_rating) as MaxRating,
		avg(user_rating) as AvgRating
from AppleStore

**Data Analysis**

--Determin whether paid apps have higher ratings than free apps

select case 
			when price > 0 then 'Paid'
			else 'Free'
			End as App_Type,
			avg(user_rating) as Avg_Rating
	From AppleStore
	Group by App_Type
	
--Check if apps with more supported languages have higher ratings

Select case 
			when lang_num < 10 then '<10 languages'
			when lang_num between 10 and 30 then '10-30 languages'
			else '>30 languages'
			End as language_bucket,
			avg(user_rating) as Avg_Rating
From AppleStore
Group by language_bucket
order by Avg_Rating DESC

--Check genres with low ratings

SELECT prime_genre,
		avg(user_rating) as Avg_Rating
From AppleStore
Group by
Order by Avg_Rating ASC
LIMIT 10

--Check if there is correlation between the length of the app description and the user rating 

SELECT CASE
			when length(b.app_desc)<500 then 'Short'
			when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
			Else 'Long'
		End as description_length_bucket,
		avg(a.user_rating) as average_rating
		
	FROM
		AppleStore as A
	JOIN
		appleStore_description_combined as B
	ON
		a.id = b.id
Group by description_length_bucket
ORDER by average_rating DESC

--Check the top-related apps for each genre

Select 
		prime_genre,
		track_name,
		user_rating
From (
		SELECT
		prime_genre,
		track_name,
		user_rating,
		RANK() OVER(PARTITION by prime_genre ORDER By user_rating DESC, rating_count_tot DESC) AS rank
		FROM
		AppleStore
	) AS a
Where 
a.rank = 1

--Paid have better ratings
--Apps supporting between 10 and 30 languages have better ratings
--Finance and book apps have low ratings
--Apps with a longer description have better ratings
--A new app should aim for an average rating above 3.5
--Games and entertainment have high competition
	