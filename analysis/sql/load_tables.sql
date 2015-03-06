
LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/a_atsigns_b.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`a_atsigns_bs`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'a_atsigns_b\t'
  (user_a_id,user_b_name,status_id)
  ;
SELECT 'a_atsigns_b', NOW(), COUNT(*) FROM `a_atsigns_bs`;

LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/a_favorites_b.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`a_favorites_bs`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'a_favorites_b\t'
  (user_a_id,user_b_id,status_id)
  ;
SELECT 'a_favorites_b', NOW(), COUNT(*) FROM `a_favorites_bs`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/a_replies_b.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`a_replies_bs`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'a_replies_b\t'
  (user_a_id,user_b_id,status_id,in_reply_to_status_id)
  ;
SELECT 'a_replies_b', NOW(), COUNT(*) FROM `a_replies_bs`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/a_retweets_b.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`a_retweets_bs`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'a_retweets_b\t'
  (user_a_id,user_b_name,status_id)
  ;
SELECT 'a_retweets_b', NOW(), COUNT(*) FROM `a_retweets_bs`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/hashtag.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`hashtags`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'hashtag\t'
  (hashtag,status_id,twitter_user_id)
  ;
SELECT 'hashtag', NOW(), COUNT(*) FROM `hashtags`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/tweet_url.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`tweet_urls`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'tweet_url\t'
  (tweet_url,status_id,twitter_user_id)
  ;
SELECT 'tweet_url', NOW(), COUNT(*) FROM `tweet_urls`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/twitter_user_profile.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`twitter_user_profiles`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'twitter_user_profile\t'
  (twitter_user_id,scraped_at,name,url,location,description,time_zone,utc_offset)
  ;
SELECT 'twitter_user_profile', NOW(), COUNT(*) FROM `twitter_user_profiles`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/twitter_user_style.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`twitter_user_styles`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'twitter_user_style\t'
  (twitter_user_id,scraped_at,profile_background_color,profile_text_color,profile_link_color,profile_sidebar_border_color,profile_sidebar_fill_color,profile_background_tile,profile_background_image_url,profile_image_url)
  ;
SELECT 'twitter_user_style', NOW(), COUNT(*) FROM `twitter_user_styles`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/twitter_user.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`twitter_users`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'twitter_user\t'
  (id,scraped_at,screen_name,protected,followers_count,friends_count,statuses_count,favourites_count,created_at)
  ;
SELECT 'twitter_user', NOW(), COUNT(*) FROM `twitter_users`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/twitter_user_partial.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`twitter_user_partials`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'twitter_user_partial\t'
  (id,scraped_at,screen_name,protected,followers_count,name,url,location,description,profile_image_url)
  ;
SELECT 'twitter_user_partial', NOW(), COUNT(*) FROM `twitter_user_partials`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/tweet.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`tweets`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'tweet\t'
  (id,created_at,twitter_user_id,favorited,truncated,in_reply_to_user_id,in_reply_to_status_id,text,source)
  ;
SELECT 'tweet', NOW(), COUNT(*) FROM `tweets`;


LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/pkgd/shorty/a_follows_b.tsv'
  REPLACE INTO TABLE        `imw_twitter_graph`.`a_follows_bs`
  COLUMNS
    TERMINATED BY           '\t'
    OPTIONALLY ENCLOSED BY  ''
    ESCAPED BY              ''
  LINES STARTING BY         'a_follows_b\t'
  (@dummy, buser_a_id,user_b_id)
  ;
SELECT 'a_follows_b', NOW(), COUNT(*) FROM `a_follows_bs`;

