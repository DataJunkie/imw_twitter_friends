REGISTER /public/share/pig/contrib/piggybank/java/piggybank.jar

TwitterUser		= LOAD 'fixd/flattened/twitter_user.tsv'                AS (rsrc: chararray, user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favorites_count: int, created_at: long);
TwitterUserPartial	= LOAD 'fixd/flattened/twitter_user_partial.tsv'        AS (rsrc: chararray, user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int,
                                                                                                                         full_name:   chararray, url: chararray, location: chararray, description: chararray, profile_image_url:chararray);
Tweet			= LOAD 'fixd/flattened/tweet.tsv'                       AS (rsrc: chararray, tw_id: int,   created_at: long, user_id: int, favorited: int, truncated: int, repl_user_id: int, repl_tw_id: int, text: chararray, src: chararray );

UserIDs_1		= FOREACH TwitterUser        GENERATE user_id, followers_count ;
UserIDs_2		= FOREACH TwitterUserPartial GENERATE user_id, followers_count ;
UserIDs_3		= FOREACH Tweet              GENERATE user_id, 1 AS followers_count ;
UserIDs_A		= UNION UserIDs_1, UserIDs_2, UserIDs_3 ;

UserIDs_G		= GROUP UserIDs_A BY user_id ;
UserIDs			= FOREACH UserIDs_G GENERATE
 			    'followers_ids' 		   AS rsrc: chararray,
                            group 			   AS user_id,
			    MAX(UserIDs_A.followers_count) AS followers_count ;
UserIDs			= ORDER UserIDs BY followers_count DESC ;
STORE UserIDs INTO 'rawd/scrape_requests-20090203';
UserIDs			= LOAD 'rawd/scrape_requests-followers_ids-20090203' AS (rsrc: chararray, user_id: int, followers_count: int);
