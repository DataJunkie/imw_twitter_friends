UPDATE TABLE `imw_twitter_friends`.twitter_users SELECT 

 (`id`, `twitter_name`, `native_id`, `last_scraped_date`, `following_count`, `followers_count`, `favorites_count`, `real_name`, `location`, `web`, `bio`, `profile_img_url`, `mini_img_url`, `bg_img_url`, `style_name_color`, `style_link_color`, `style_text_color`, `style_bg_color`, `style_sidebar_fill_color`, `style_sidebar_border_color`, `style_bg_img_tile`, `updates_count`)


REPLACE INTO `imw_twitter_friends`.twitter_users 
   (`id`, `twitter_name`, `native_id`, `last_scraped_date`, `following_count`, `followers_count`, `favorites_count`, `real_name`, `location`, `web`, `bio`, `profile_img_url`, `mini_img_url`, `bg_img_url`, `style_name_color`, `style_link_color`, `style_text_color`, `style_bg_color`, `style_sidebar_fill_color`, `style_sidebar_border_color`, `style_bg_img_tile`, `updates_count`)
  SELECT `id`, `twitter_name`, `twitter_id`, `last_scraped_date`, `following_count`, `followers_count`, `favorites_count`, `real_name`, `location`, `web`, `bio`, `profile_img_url`, `mini_img_url`, `bg_img_url`, `style_name_color`, `style_link_color`, `style_text_color`, `style_bg_color`, `style_sidebar_fill_color`, `style_sidebar_border_color`, `style_bg_img_tile`, `updates_count`
  FROM  `imw_twitter_friends_old`.users ou
  WHERE ou.id < 50

REPLACE INTO `imw_twitter_friends`.asset_requests
  (`uri`,`priority`,`scraped_time`,`twitter_user_id`,`user_resource`,`page`,`twitter_name`)
SELECT concat('http://twitter.com/statuses/followers/', u.twitter_name, '.json?page=1') AS uri,
  pr.prestige AS priority, NULL AS scraped_time, u.id AS twitter_user_id, "followers" AS user_resource, 1 AS page, u.twitter_name
  FROM  `imw_twitter_friends`.twitter_users u,
  `imw_twitter_friends`.twitter_page_ranks pr 
  WHERE pr.twitter_user_id = u.id 
  ORDER BY pr.prestige ASC
  LIMIT 20
  
REPLACE INTO `imw_twitter_friends`.asset_requests
  (`uri`,`priority`,`scraped_time`,`twitter_user_id`,`user_resource`,`page`,`twitter_name`)
SELECT concat('http://twitter.com/statuses/friends/', u.twitter_name, '.json?page=1') AS uri,
  pr.prestige AS priority, NULL AS scraped_time, u.id AS twitter_user_id, "friends" AS user_resource, 1 AS page, u.twitter_name
  FROM  `imw_twitter_friends`.twitter_users u,
  `imw_twitter_friends`.twitter_page_ranks pr 
  WHERE pr.twitter_user_id = u.id 
  ORDER BY pr.prestige ASC
  LIMIT 20

UPDATE `imw_twitter_friends`.asset_requests a,  `imw_twitter_friends`.twitter_users u
  SET a.twitter_name = u.twitter_name
  WHERE a.twitter_user_id = u.id
  AND   a.prestige < 20

REPLACE INTO `imw_twitter_friends`.asset_requests
  (`uri`,`priority`,`scraped_time`,`twitter_user_id`,`user_resource`,`page`,`twitter_name`)
SELECT concat('http://twitter.com/', u.twitter_name) AS uri,
  pr.prestige AS priority, NULL AS scraped_time, u.id AS twitter_user_id, "parse" AS user_resource, 1 AS page, u.twitter_name
  FROM  `imw_twitter_friends`.twitter_users u,
  `imw_twitter_friends`.twitter_page_ranks pr 
  WHERE pr.twitter_user_id = u.id 
  ORDER BY pr.prestige ASC
  LIMIT 20
  
