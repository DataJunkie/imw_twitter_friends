
-- Unprocess users with more than one page of followers
SELECT COUNT(*), 10000*CEILING(a.priority/10000) AS bin, COUNT(IF(followers_count > 100, 1, NULL)) AS popular
  from twitter_users u, asset_requests a
  WHERE 	u.id = a.twitter_user_id
  AND 		a.user_resource = 'parse' AND a.scraped_time IS NULL
  GROUP BY bin



LOAD DATA INFILE "~/ics/pool/social/network/twitter_friends/fixd/dump/imw_twitter_friends-friendships-20081116-dump-ranks.tsv"
      REPLACE INTO TABLE twitter_page_ranks
      FIELDS TERMINATED BY "\t"
      (`prestige`, `twitter_user_id`, `page_rank`)
;

SELECT u.twitter_name, u.following_count, u.followers_count, u.updates_count, pr.page_rank, pr.prestige
  FROM
    (SELECT * FROM twitter_page_ranks  ORDER BY prestige ASC LIMIT 100) pr
  LEFT JOIN users u ON u.id = pr.twitter_user_id
  ORDER BY prestige ASC
;


-- Stages of parsing
SELECT COUNT(*),
       COUNT(last_scraped_date), COUNT(last_scraped_date)/COUNT(*),
       COUNT(native_id), 	 COUNT(native_id)/COUNT(*),
       COUNT(following_count),	 COUNT(following_count)/COUNT(*),
       COUNT(followers_count), 	 COUNT(followers_count)/COUNT(*)
FROM twitter_users

--
-- Look at lengths
--
SELECT COUNT(*), ll.l_bio AS len
  FROM ( SELECT LENGTH(`twitter_name`) 	AS l_twitter_name,
      LENGTH(`real_name`)  		AS l_real_name,
      LENGTH(`location`)  		AS l_location,
      LENGTH(`web`) 			AS l_url,
      LENGTH(`bio`) 			AS l_bio,
      LENGTH(`style_profile_img_url`)  	AS l_pr_url,
      LENGTH(`style_mini_img_url`)  	AS l_mini_url,
      LENGTH(`style_bg_img_url`) 		AS l_bg_url
    FROM `users`
    WHERE 1 ) ll
  GROUP BY len
  ORDER BY len DESC

--
-- Fiddle with stuff
--
SELECT LENGTH(`twitter_name`) 	AS l_twitter_name,
      LENGTH(`real_name`)  		AS l_real_name,
      LENGTH(`location`)  		AS l_location,
      LENGTH(`web`) 			AS l_url,
      LENGTH(`bio`) 			AS l_bio,
      LENGTH(`style_profile_img_url`)  	AS l_pr_url,
      LENGTH(`style_mini_img_url`)  	AS l_mini_url,
      LENGTH(`style_bg_img_url`) 	AS l_bg_url, U.*
    FROM `users` U
    WHERE twitter_id IS NOT NULL AND style_mini_img_url IS NOT NULL
    ORDER BY twitter_id



SELECT u.*
  FROM users u
  WHERE    	(0 OR u.parsed IS NOT NULL)
  AND      	(1 OR u.id MOD 1000 = 0)
  AND 		(u.twitter_name NOT LIKE "\_%")
  ORDER BY 	u.twitter_name 	DESC,
			IFNULL(u.twitter_ID, 1000000) ASC,
			u.followers_count DESC
  LIMIT 1000
