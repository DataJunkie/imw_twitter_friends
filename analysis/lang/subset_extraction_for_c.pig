
RedTweets_1 	= FILTER Tweet BY (created_at > 20081100000000L) ;
RedTweets_2 	= FOREACH RedTweets_1 GENERATE
  tw_id, created_at, user_id, favorited, truncated, repl_user_id, repl_tw_id, text, src, (int)(created_at % 100) AS rand_idx;
RedTweets_3 	= FILTER RedTweets_2 BY rand_idx == 42 ;
RedTweets_4 	= LIMIT RedTweets_3 10000 ;
STORE RedTweets_4 INTO 'foo/red_tweets.tsv' ;


RedTweetsCount_1 = GROUP RedTweets_4 ALL ;
RedTweetsCount   = FOREACH RedTweetsCount_1 GENERATE COUNT(RedTweets_4) ;

DUMP RedTweetsCount ;
