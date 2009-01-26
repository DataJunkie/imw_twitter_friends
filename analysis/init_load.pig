--
-- UDF Stores
--
REGISTER /public/share/pig/contrib/piggybank/java/piggybank.jar ;

--
-- Twitter Model classes
--
AFollowsB       = LOAD 'fixd/flattened/a_follows_b.tsv'                 AS (rsrc: chararray, user_a_id: int, user_b_id: int);
ARetweetsB_N    = LOAD 'fixd/flattened/a_retweets_b.tsv'                AS (rsrc: chararray, user_a_id: int, user_b_name: chararray,    tw_id: int, pls_flag:int, text:chararray);
AAtsignsB_N     = LOAD 'fixd/flattened/a_atsigns_b.tsv'                 AS (rsrc: chararray, user_a_id: int, user_b_name: chararray,    tw_id: int);
ARepliesB       = LOAD 'fixd/flattened/a_replies_b.tsv'                 AS (rsrc: chararray, user_a_id: int, user_b_id: int,            tw_id: int, reply_tw_id:int);
AFavoritesB     = LOAD 'fixd/flattened/a_favorites_b.tsv'               AS (rsrc: chararray, user_a_id: int, user_b_id: int,            tw_id: int);

TweetUrl        = LOAD 'fixd/flattened/tweet_url.tsv'                   AS (rsrc: chararray, url: chararray, tw_id: int, user_id: int);
HashTag         = LOAD 'fixd/flattened/hashtag.tsv'                     AS (rsrc: chararray, url: chararray, tw_id: int, user_id: int);

Users           = LOAD 'fixd/flattened/twitter_user.tsv'                AS (rsrc: chararray, user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favorites_count: int, created_at: long);
UserPartials    = LOAD 'fixd/flattened/twitter_user_partial.tsv'        AS (rsrc: chararray, user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int,
                                                                                                                             full_name:   chararray, url: chararray, location: chararray, description: chararray, profile_image_url:chararray);
UserProfiles    = LOAD 'fixd/flattened/twitter_user_profile.tsv'        AS (rsrc: chararray, user_id: int, scraped_at: long, full_name:   chararray, url: chararray, location: chararray, description: chararray, time_zone: chararray, utc_offset: int);
UserStyles      = LOAD 'fixd/flattened/twitter_user_style.tsv'          AS (rsrc: chararray, user_id: int, scraped_at: long, profile_background_color: chararray, profile_text_color: chararray, profile_link_color: chararray, profile_sidebar_border_color: chararray, profile_sidebar_fill_color: chararray, profile_background_tile: int, profile_background_image_url: chararray, profile_image_url: chararray);

Tweets          = LOAD 'fixd/flattened/tweet.tsv'                       AS (rsrc: chararray, tw_id: int,   created_at: long, user_id: int, favorited: int, truncated: int, repl_user_id: int, repl_tw_id: int, text: chararray, src: chararray );
