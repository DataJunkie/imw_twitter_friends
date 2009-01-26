use `imw_twitter_graph`

-- See histograms.sql for figures

-- ***************************************************************************
--
-- Primary user information
--
--
DROP TABLE IF EXISTS  `imw_twitter_graph`.`twitter_users`;
CREATE TABLE          `imw_twitter_graph`.`twitter_users` (
  `id`                                  INT(10) UNSIGNED                        NOT NULL, -- at 17_751_380 on 11/30/08
  `scraped_at`                          DATETIME                                NOT NULL, --
  `screen_name`                         VARCHAR(20) CHARACTER SET ASCII         NOT NULL, -- careful: there are a few bogus screen names, with non-ascii chars even.
  `protected`                           TINYINT(4)    UNSIGNED, 			  --
  `followers_count`                     MEDIUMINT(10) UNSIGNED,
  `friends_count`                       MEDIUMINT(10) UNSIGNED,
  `statuses_count`                      MEDIUMINT(10) UNSIGNED,                           -- good for a few more years, and Market_JP is a little bitch
  `favourites_count`                    MEDIUMINT(10) UNSIGNED,
  `created_at`                          DATETIME                                NOT NULL, --
  PRIMARY KEY   (`id`),
  INDEX  (`screen_name`(20)), -- There *actually* are duplicate screen names, but you can UNIQUE this if you don't care about that edge case.
  INDEX         (`followers_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

--                     Max          50%ile,non-blank  99.9%ile incl.blk
--   screen_name        20 chars 		         15 	    
--   name               60           9.5                 24        
--   url               100          28   		 81                  	                  
--   location           80          11.5                 38      
--   description       255          44                  212         -- can be 255*4 in principle (UTF-8) (??)
--   time_zone 		28 	    -- 			 --
--   profile_image_url                                  167        

DROP TABLE IF EXISTS  `imw_twitter_graph`.`twitter_user_partials`;
CREATE TABLE          `imw_twitter_graph`.`twitter_user_partials` (
  `id`                                  INT(10) UNSIGNED                        NOT NULL, -- at 17_751_380 on 11/30/08
  `scraped_at`                          DATETIME                                NOT NULL, --
  `screen_name`                         VARCHAR(20) CHARACTER SET ASCII         NOT NULL, --
  `protected`                           TINYINT(4)    UNSIGNED, 			  --
  `followers_count`                     MEDIUMINT(10) UNSIGNED,
  `name`                                VARCHAR(180) CHARACTER SET ASCII,		# 60  but XML-encoded so needs extra space & may truncate
  `url`                                 VARCHAR(100) CHARACTER SET ASCII,
  `location`                            VARCHAR(240) CHARACTER SET ASCII,		# 80  but XML-encoded so needs extra space & may truncate
  `description`                         VARCHAR(511) CHARACTER SET ASCII,		# 255 but XML-encoded so needs extra space & may truncate
  `profile_image_url`                   VARCHAR(255) CHARACTER SET ASCII,
  PRIMARY KEY   (`id`),
  INDEX  (`screen_name`(20)), -- There *actually* are duplicate screen names, but you can UNIQUE this if you don't care about that edge case.
  INDEX         (`followers_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

-- id      followers_count protected       screen_name name    url     description     location        profile_image_url
--
--
-- Descriptive
--
--
DROP TABLE IF EXISTS  `imw_twitter_graph`.`twitter_user_profiles`;
CREATE TABLE          `imw_twitter_graph`.`twitter_user_profiles` (
  `twitter_user_id`                     INT(10) UNSIGNED                        NOT NULL,
  `scraped_at`                          DATETIME                                NOT NULL, --
  `name`                                VARCHAR(180) CHARACTER SET ASCII,		# 60  but XML-encoded so needs extra space & may truncate
  `url`                                 VARCHAR(100) CHARACTER SET ASCII,
  `location`                            VARCHAR(240) CHARACTER SET ASCII,		# 80  but XML-encoded so needs extra space & may truncate
  `description`                         VARCHAR(511) CHARACTER SET ASCII,		# 255 but XML-encoded so needs extra space & may truncate
  `time_zone`                           VARCHAR(30)  CHARACTER SET ASCII, 
  `utc_offset`                          MEDIUMINT(7),                     
  PRIMARY KEY  (`twitter_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

--
--
-- Style
--
--
DROP TABLE IF EXISTS  `imw_twitter_graph`.`twitter_user_styles`;
CREATE TABLE          `imw_twitter_graph`.`twitter_user_styles` (
  `twitter_user_id`                     INT(10)  UNSIGNED                       NOT NULL,
  `scraped_at`                          DATETIME                                NOT NULL, --
  `profile_background_color`            CHAR(6)      CHARACTER SET ASCII,
  `profile_text_color`                  CHAR(6)      CHARACTER SET ASCII,
  `profile_link_color`                  CHAR(6)      CHARACTER SET ASCII,
  `profile_sidebar_border_color`        CHAR(6)      CHARACTER SET ASCII,
  `profile_sidebar_fill_color`          CHAR(6)      CHARACTER SET ASCII,
  `profile_background_tile`             TINYINT(4) UNSIGNED,
  `profile_background_image_url`        VARCHAR(255) CHARACTER SET ASCII,
  `profile_image_url`                   VARCHAR(255) CHARACTER SET ASCII,
  PRIMARY KEY  (`twitter_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


-- Derived user information
-- -- also followers, friends, favorites, etc from
--
-- make sure to record 
-- 
DROP TABLE IF EXISTS  `imw_twitter_graph`.`twitter_user_metrics`;
CREATE TABLE          `imw_twitter_graph`.`twitter_user_metrics` (
  `twitter_user_id`                  INT(10) UNSIGNED NOT NULL,
  `twitter_user_created_at`          DATETIME,                   -- Denormalized
  `scraped_at`                       DATETIME,
  `statuses_count_at_update`         MEDIUMINT(10) UNSIGNED,
  `tweet_rate`                       DECIMAL(9,5)  UNSIGNED,
  `atsigns_count`                    MEDIUMINT(10) UNSIGNED,
  `atsigned_count`                   MEDIUMINT(10) UNSIGNED,
  `tweet_urls_count`                 MEDIUMINT(10) UNSIGNED,
  `hashtags_count`                   MEDIUMINT(10) UNSIGNED,
  `twoosh_count`                     MEDIUMINT(10) UNSIGNED,
  `prestige`                         INT(10)       UNSIGNED,
  `pagerank`                         FLOAT,
  `has_image`                        TINYINT(4)    UNSIGNED,
  `lat`                              FLOAT,
  `lng`                              FLOAT,
  PRIMARY KEY  (`twitter_user_id`),
  UNIQUE INDEX (`prestige`, `twitter_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

-- ***************************************************************************
--
-- Tweets (statuses)
--
-- Note spelling of favo**U**rite
-- Enforcing that we never see a tweet w/o seeing the whole thing.
--
-- 
-- note that twitter is 25% of the way to overflowing a 32bit key.
--
-- An xml-entity-encoded string will WAY overflow 140. In a sample of 40M tweets,
-- 57k (1.4%) were longer than 511, 16k were longer than 767, and the longest was
-- a whopping 1792 chars. yow.
--
DROP TABLE IF EXISTS  `imw_twitter_graph`.`tweets`;
CREATE TABLE          `imw_twitter_graph`.`tweets` (
  `id`                                  INT(10) UNSIGNED                        NOT NULL,  
  `created_at`                          DATETIME                                NOT NULL,
  `twitter_user_id`                     INT(10) UNSIGNED                        NOT NULL,
  `favorited`                           TINYINT(4)   UNSIGNED                   NOT NULL,
  `truncated`                           TINYINT(4)   UNSIGNED                   NOT NULL,
  `in_reply_to_user_id`                 INT(10)      UNSIGNED                   NOT NULL,
  `in_reply_to_status_id`               INT(10)      UNSIGNED                   NOT NULL,   
  `text`                                VARCHAR(768) CHARACTER SET ASCII	NOT NULL,  # 140 but XML-encoded so needs extra space & may truncate
  `source`                              VARCHAR(80)  CHARACTER SET ASCII        NOT NULL,
  PRIMARY KEY  (`id`),
  INDEX (`created_at`),
  INDEX (`twitter_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

-- ***************************************************************************
--
-- Relationships
--
-- 
--
-- Tweets and derived entities are immutable, so we don't need the scraped_at
--
DROP TABLE IF EXISTS  `imw_twitter_graph`.`a_follows_bs`;
CREATE TABLE          `imw_twitter_graph`.`a_follows_bs` (
  `user_a_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `user_b_id`                           INT(10)      UNSIGNED                   NOT NULL,
  PRIMARY KEY   (`user_a_id`,   `user_b_id`),
  INDEX         (`user_b_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS  `imw_twitter_graph`.`a_symmetric_bs`;
CREATE TABLE          `imw_twitter_graph`.`a_symmetric_bs` (
  `user_a_id`           INT(10)      UNSIGNED                   NOT NULL,
  `user_b_id`           INT(10)      UNSIGNED                   NOT NULL,
  PRIMARY KEY   (`user_a_id`, `user_b_id`),
  INDEX         (`user_b_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS  `imw_twitter_graph`.`a_favorites_bs`;
CREATE TABLE          `imw_twitter_graph`.`a_favorites_bs` (
  `user_a_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `user_b_id`                           INT(20)      UNSIGNED                   NOT NULL,
  `status_id`                           INT(10)      UNSIGNED                   NOT NULL,
  PRIMARY KEY   (`user_a_id`, `status_id`),
  INDEX         (`user_a_id`, `user_b_id`)
  -- INDEX         (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS  `imw_twitter_graph`.`a_replies_bs`;
CREATE TABLE          `imw_twitter_graph`.`a_replies_bs` (
  `user_a_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `user_b_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `status_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `in_reply_to_status_id`               INT(10)      UNSIGNED                   NOT NULL,
  PRIMARY KEY   (`user_a_id`, `user_b_id`, `status_id`),
  INDEX         (`user_b_id`)
  -- INDEX         (`status_id`),
  -- INDEX         (`in_reply_to_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

-- could shorten the user_b_name part of primary key if you wanted
DROP TABLE IF EXISTS  `imw_twitter_graph`.`a_atsigns_bs`;
CREATE TABLE          `imw_twitter_graph`.`a_atsigns_bs` (
  `user_a_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `user_b_name`                         VARCHAR(20)  CHARACTER SET ASCII        NOT NULL, 
  `status_id`                           INT(10)      UNSIGNED                   NOT NULL,
  PRIMARY KEY   (`user_a_id`, `user_b_name`(20), `status_id`),
  INDEX         (`user_b_name`)
  -- INDEX         (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS  `imw_twitter_graph`.`a_retweets_bs`;
CREATE TABLE          `imw_twitter_graph`.`a_retweets_bs` (
  `user_a_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `user_b_name`                         VARCHAR(20)  CHARACTER SET ASCII        NOT NULL, 
  `status_id`                           INT(10)      UNSIGNED                   NOT NULL,
  PRIMARY KEY   (`user_a_id`, `status_id`),
  INDEX         (`user_a_id`, `user_b_name`)
  -- INDEX         (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

-- ***************************************************************************
--
-- Text elements
--
--

-- OK so 92% of all hashtags are 12 chrs or fewer
-- and we're including the status_id in the primary key
-- so if you use two hashtags identical (and longer than) 12
-- then, well, screw you pal.  (we use LOAD ... IGNORE so it's not screw us)
-- also though I suppose 139 chars is the max, 40 chars covers 99.98% of the tags
DROP TABLE IF EXISTS  `imw_twitter_graph`.`hashtags`;
CREATE TABLE          `imw_twitter_graph`.`hashtags` (
  `hashtag`                             VARCHAR(40)  CHARACTER SET ASCII        NOT NULL,       -- have to make sure open text is encoded
  `status_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `twitter_user_id`                     INT(10)      UNSIGNED                   NOT NULL,
  PRIMARY KEY   (`hashtag`(25), `status_id`),
  INDEX         (`hashtag`(25), `twitter_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

DROP TABLE IF EXISTS  `imw_twitter_graph`.`tweet_urls`;
CREATE TABLE          `imw_twitter_graph`.`tweet_urls` (
  `tweet_url`                           VARCHAR(140) CHARACTER SET ASCII        NOT NULL,       -- have to make sure open text is encoded
  `status_id`                           INT(10)      UNSIGNED                   NOT NULL,
  `twitter_user_id`                     INT(10)      UNSIGNED                   NOT NULL,
  INDEX         (`twitter_user_id`),
  --  INDEX         (`status_id`),
  INDEX         (`tweet_url`(40))
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


-- --
-- -- Resolve all the tinyurls, bitlys, snurls, etc.
-- --
-- --
-- DROP TABLE IF EXISTS  `imw_twitter_graph`.`expanded_urls`;
-- CREATE TABLE          `imw_twitter_graph`.`expanded_urls` (
--   `src_url`                           VARCHAR(60)      CHARACTER SET ASCII    NOT NULL,
--   `dest_url`                            VARCHAR(1024)    CHARACTER SET ASCII    NULL,
--   `scraped_at`                          DATETIME                                NULL,
--   PRIMARY KEY   (`src_url`(40)),
--   INDEX         (`dest_url`(40))
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;

-- DROP TABLE IF EXISTS  `imw_twitter_graph`.`tinyurl_stubs`;
-- CREATE TABLE          `imw_twitter_graph`.`tinyurl_stubs` (
--   `id`                                  INTEGER         UNSIGNED AUTO_INCREMENT,
--   `stub`                                VARCHAR(15)      CHARACTER SET ASCII    NOT NULL,
--   PRIMARY KEY    (`id`),
--   UNIQUE INDEX   (`stub`(15))
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- LOAD DATA INFILE '~/ics/pool/social/network/twitter_friends/fixd/dump/tinyurl_stubs.txt'
--   INTO TABLE `imw_twitter_graph`.`tinyurl_stubs` (`stub`)
-- ;

-- ===========================================================================
--
-- Data gathering tables
--

--
-- Scrape Requests
--
-- This kind of URL has 74 chars ; let's call it 96
-- 
-- http://twitter.com/statuses/followers/twentycharacter_name.json?page=54321
-- 0----.----1----.----2----.----3----.----4----.----5----.----6----.----7---
--

-- DROP TABLE IF EXISTS  `imw_twitter_graph`.`scrape_requests`;
-- CREATE TABLE          `imw_twitter_graph`.`scrape_requests` (
--   `twitter_user_id`                     INT(10)         UNSIGNED                NOT NULL,
--   `context`                             ENUM('user', 'followers', 'friends')    NOT NULL,
--   `page`                                SMALLINT(10)    UNSIGNED                NOT NULL,
--   `priority`                            INTEGER                                 NOT NULL        DEFAULT 0,
--   `scraped_at`                          DATETIME,
--   `result_code`                         SMALLINT(6)     UNSIGNED,
--   PRIMARY KEY   (`twitter_user_id`, `context`, `page`),
--   INDEX  	(`scraped_at`),
--   INDEX  	(`context`),
--   INDEX 	(`priority`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- --  `uri`                                 VARCHAR(96)                             NOT NULL,
-- --  `requested_at`                        DATETIME,
-- 
-- 
-- 
-- DROP TABLE IF EXISTS  `imw_twitter_graph`.`scrape_request_pages`;
-- CREATE TABLE          `imw_twitter_graph`.`scrape_request_pages` (
--   `twitter_user_id`                     INT(10)         UNSIGNED                NOT NULL,
--   `context`                             ENUM('user', 'followers', 'friends')    NOT NULL,
--   `page`                                SMALLINT(10)    UNSIGNED                NOT NULL,
--   PRIMARY KEY   (`twitter_user_id`, `context`, `page`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- 
-- 
-- --
-- -- Scraped files
-- --
-- -- mode hl user grp size date time filename
-- --
-- -- Note you only get one per scrape_session -- assumedly your filesystem
-- -- enforces this as well also note that the filename is *not* forced to
-- -- case-sensitivity, which your filesystem might or might not be.
-- --
-- -- twentycharacter_name.json%3Fpage%3D54321+20081129-052555.json
-- -- 0----.----1----.----2----.----3----.----4----.----5----.----6 -- 61 chars
-- --
-- -- DROP TABLE IF EXISTS  `imw_twitter_graph`.`scraped_file_index`;
-- CREATE TABLE          `imw_twitter_graph`.`scraped_file_index` (
--   `screen_name`                         VARCHAR(20)                             NOT NULL,
--   `twitter_user_id`                     INTEGER         UNSIGNED                NULL,
--   `context`                             ENUM('user', 'followers', 'friends')    NOT NULL,
--   `page`                                SMALLINT(10)    UNSIGNED                NOT NULL,
--   `size`                                INTEGER,
--   `scraped_at`                          DATETIME                                DEFAULT NULL,
--   `scrape_session`                      DATE,  
--   PRIMARY KEY   (`screen_name`,     `context`, `page`, `scrape_session`),
--   INDEX         (`twitter_user_id`, `context`, `page`),
--   INDEX         (`context`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
-- --  `filename`                            VARCHAR(80)  CHARACTER SET ASCII       DEFAULT NULL,


-- ALTER TABLE `scraped_file_index` ADD `twitter_user_id` INT UNSIGNED NULL FIRST ;
-- ALTER TABLE `scraped_file_index` ADD INDEX ( `twitter_user_id` ) ;

-- 
-- The wacky-assed denormalized boolean columns let you make a weighted graph by
-- combining the sum of each column times that column's weight.
--
-- Also note you can  find symmetric relationships without a JOIN : use a UNION and GROUP BY
  
--
-- afollowsb     time  1 0 0 0 0        user_a_id       user_b_id
-- afavoredb     time  0 1 0 0 0        user_a_id       user_b_id
-- arepliesb     time  0 0 1 0 0        user_a_id       user_b_id       status_id
-- aatsigndb     time  0 0 0 1 0        user_a_id       user_b_id       status_id
-- bothfollw     time  0 0 0 0 1        user_a_id       user_b_id       status_id
--
-- The wacky-assed denormalized boolean columns let you make a weighted graph by
-- combining the sum of each column times that column's weight.
--
-- Also note you can  find symmetric relationships without a JOIN : use a UNION and GROUP BY
--
-- -- `rel`                                     ENUM('afollowsb', 'afavoredb', 'arepliesb', 'aatsigndb', 'bothfollw'),
-- --   `status_id`                             INT(10)      UNSIGNED                   NOT NULL DEFAULT 0,   -- note that twitter is 25% of the way to overflow.
-- --   `reltime`                               DATETIME                                NOT NULL,
-- --   `afollowsb`                             TINYINT                                 DEFAULT NULL, -- boolean
-- --   `afavoredb`                             TINYINT                                 DEFAULT NULL, -- boolean
-- --   `arepliesb`                             TINYINT                                 DEFAULT NULL, -- boolean
-- --   `aatsignb`                              TINYINT                                 DEFAULT NULL, -- boolean
-- --   `bothfollw`                             TINYINT                                 DEFAULT NULL, -- boolean ?? do we want reverse links too ??
-- --   PRIMARY KEY  (`rel`, `user_a_id`, `user_b_id`, `status_id`),
-- --   INDEX   (`user_a_id`, `user_b_id`),
-- --   INDEX   (`user_b_id`),
-- --   INDEX   (`status_id`),
-- --   INDEX   (`reltime`)
-- -- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- -- ;
-- --
-- -- hashtag    time  1 0 0    user_a_id                       status_id       sha1(hashtag)
-- -- url                time  0 1 0    user_a_id                       status_id       sha1(url)
-- -- word               time  0 0 1    user_a_id                                       sha1(word)
-- --
-- DROP TABLE IF EXISTS  `imw_twitter_graph`.`text_relationships`;
-- CREATE TABLE          `imw_twitter_graph`.`text_relationships` (
--   `rel`                                      ENUM('hashtag', 'url', 'word'),
--   `user_a_id`                                INT(10)      UNSIGNED                   NOT NULL,
--   `status_id`                                INT(10)      UNSIGNED,
--   `reltime`                          DATETIME                                NOT NULL,
--   `fragment_hash`                    BINARY(20)                              NOT NULL,
--
--   `hashtag`                          TINYINT                                 DEFAULT NULL,   -- boolean
--   `url`                                      TINYINT                                 DEFAULT NULL,   -- boolean
--   `word`                             TINYINT                                 DEFAULT NULL,   -- not boolean: tinyint.
--   `scraped_at`                               DATETIME                                NOT NULL, --
--   PRIMARY KEY  (`rel`, `user_a_id`, `fragment`(25), `status_id`),
--   INDEX (`user_a_id`),
--   INDEX (`fragment_hash`),
--   INDEX (`fragment`(25)),
--   INDEX (`reltime`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ;
