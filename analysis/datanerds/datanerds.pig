--
-- evaluate init_load.pig first
--

-- ===========================================================================
--
-- Gather intial community, hand-seeded
--
SeedNames 	= LOAD 'meta/datanerds/seedlist.txt' AS (screen_name: chararray) ;

-- collect id's
-- SeedUsers_1     = JOIN SeedNames BY screen_name, Users BY screen_name ;
-- SeedUsers       = FOREACH SeedUsers_1 GENERATE user_id AS user_id, scraped_at AS scraped_at, Users::screen_name AS screen_name, protected AS protected, followers_count AS followers_count, friends_count AS friends_count, statuses_count AS statuses_count, favorites_count AS favorites_count, created_at AS created_at ;
-- STORE SeedUsers   INTO 'meta/datanerds/seed_users.tsv' ;
-- SeedIDs         = FOREACH SeedUsers GENERATE user_id ;
-- STORE SeedIDs     INTO 'meta/datanerds/seed_ids.tsv' ;

SeedUsers       = LOAD 'meta/datanerds/seed_users.tsv' AS (user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favorites_count: int, created_at: long);
SeedIDs         = LOAD 'meta/datanerds/seed_ids.tsv'   AS (user_id: int) ;

-- ===========================================================================
--
-- Identify twitter whores: follows a lot of people AND 50% more people than
-- follow back, OR follow/followed by a ton of people.
--

-- TwitterWhores_1      = FILTER Users
--   BY ((1.0*friends_count  > 1000) AND (1.0*friends_count/followers_count > 1.50))
--   OR (1.0*friends_count   > 10000)
--   OR (1.0*followers_count > 10000) ;
-- TwitterWhores        = FOREACH TwitterWhores_1 GENERATE user_id, screen_name, (1.0*friends_count/followers_count) AS neediness:double, followers_count, friends_count ;
-- STORE TwitterWhores INTO 'meta/datanerds/twitter_whores.tsv' ;
-- TwitterWhoreIDs = FOREACH TwitterWhores GENERATE user_id ;
-- STORE TwitterWhoreIDs INTO 'meta/datanerds/twitter_whore_ids.tsv' ;

TwitterWhores   = LOAD 'meta/datanerds/twitter_whores.tsv'      AS (user_id:int, screen_name:chararray, neediness:double, followers_count:int, friends_count:int) ;
TwitterWhoreIDs = LOAD 'meta/datanerds/twitter_whore_ids.tsv'   AS (user_id: int) ;

-- ===========================================================================
--
-- Collect all who either friend or follow anyone the seed list
--

-- Nbhd1In_1     = JOIN  SeedIDs         BY user_id, ARepliesB BY user_b_id PARALLEL 12;
-- Nbhd1In       = FOREACH Nbhd1In_1   GENERATE user_a_id, user_b_id ;
-- STORE Nbhd1In INTO 'meta/datanerds/nbhd_1_in.tsv' ;
--
--
-- Nbhd1Out_1    = JOIN SeedIDs          BY user_id, ARepliesB BY user_a_id PARALLEL 12;
-- Nbhd1Out      = FOREACH Nbhd1Out_1  GENERATE user_a_id, user_b_id ;
-- STORE Nbhd1Out INTO 'meta/datanerds/nbhd_1_out.tsv' ;

-- Choose distinct names in the 1-neighborhood, and ppend the seed list
-- (shouldn't be necessary, but let's be smart and not clever).

-- Nbhd1In_IDs   = FOREACH Nbhd1In     GENERATE user_a_id AS user_id;
-- Nbhd1Out_IDs  = FOREACH Nbhd1Out    GENERATE user_b_id AS user_id;
-- Nbhd1IDs_1    = UNION Nbhd1In_IDs, Nbhd1Out_IDs, SeedIDs ;
-- Nbhd1IDs_2    = DISTINCT Nbhd1IDs_1 ;
-- -- Eliminate edges to people on the whore list. (Note that they'll come in to
-- -- the universe when we find the two-neighborhood, just their edges won't)
-- Nbhd1IDs_3      = COGROUP       Nbhd1IDs_2          BY user_id OUTER, TwitterWhoreIDs BY user_id OUTER PARALLEL 1;
-- Nbhd1IDs_4      = FILTER        Nbhd1IDs_3          BY COUNT(TwitterWhoreIDs) == 0;
-- Nbhd1IDs_5      = FOREACH       Nbhd1IDs_4          GENERATE group AS user_id;
-- STORE Nbhd1IDs_5 INTO 'meta/datanerds/nbhd_1_ids.tsv' ;

-- FIXME !!!! ;
-- STORE Nbhd1IDs INTO 'meta/datanerds/nbhd_1_ids.tsv' ;

Nbhd1In       = LOAD 'meta/datanerds/nbhd_1_in.tsv'   AS (user_a_id: int, user_b_id: int);
Nbhd1Out      = LOAD 'meta/datanerds/nbhd_1_out.tsv'  AS (user_a_id: int, user_b_id: int);
Nbhd1IDs      = LOAD 'meta/datanerds/nbhd_1_ids.tsv'  AS (user_id: int);
-- Nbhd1In_Users = JOIN Nbhd1In BY user_a_id, Users BY user_id; STORE Nbhd1In_Users INTO 'meta/datanerds/Nbhd1In_Users.tsv' ;

-- ===========================================================================
--
-- Now collect all incoming and outgoing links between people in this one-neighborhood.
--
Nbhd2In_1       = JOIN  Nbhd1IDs      BY user_id, ARepliesB BY user_b_id PARALLEL 12;
Nbhd2In_2       = FILTER Nbhd2In_1    BY (Nbhd1IDs::user_id IS NOT NULL);
Nbhd2In         = FOREACH Nbhd2In_2   GENERATE user_a_id, user_b_id ;
STORE Nbhd2In INTO 'meta/datanerds/nbhd_2_in.tsv' ;

Nbhd2Out_1      = JOIN Nbhd1IDs       BY user_id, ARepliesB BY user_a_id PARALLEL 12;
Nbhd2Out_2      = FILTER  Nbhd2Out_1  BY (Nbhd1IDs::user_id IS NOT NULL);
Nbhd2Out        = FOREACH Nbhd2Out_2  GENERATE user_a_id, user_b_id ;
STORE Nbhd2Out INTO 'meta/datanerds/nbhd_2_out.tsv' ;

Nbhd2IDs_1      = FOREACH Nbhd2Out GENERATE user_b_id           AS user_id;
Nbhd2IDs_2      = FOREACH Nbhd2In  GENERATE user_a_id           AS user_id;
Nbhd2IDs_3      = UNION Nbhd2IDs_1, Nbhd2IDs_2, Nbhd1IDs ;
Nbhd2IDs        = DISTINCT Nbhd2IDs_3 ;
STORE Nbhd2IDs INTO 'meta/datanerds/nbhd_2_ids.tsv' ;
Nbhd2Users_1    = JOIN Nbhd2IDs BY user_id, Users BY user_id;
Nbhd2Users      = FOREACH Nbhd2Users_1 GENERATE Users::user_id AS user_id, scraped_at AS scraped_at, Users::screen_name AS screen_name, protected AS protected, followers_count AS followers_count, friends_count AS friends_count, statuses_count AS statuses_count, favorites_count AS favorites_count, created_at AS created_at ;
STORE Nbhd2Users INTO 'meta/datanerds/nbhd_2_users.tsv' ;

Nbhd2In         = LOAD 'meta/datanerds/nbhd_2_in.tsv'           AS (user_a_id: int, user_b_id: int);
Nbhd2Out        = LOAD 'meta/datanerds/nbhd_2_out.tsv'          AS (user_a_id: int, user_b_id: int);
Nbhd2IDs        = LOAD 'meta/datanerds/nbhd_2_ids.tsv'          AS (user_id: int);
Nbhd2Users      = LOAD 'meta/datanerds/nbhd_2_users.tsv'        AS (user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favorites_count: int, created_at: long);

Nbhd2OutUsers_1 = JOIN Nbhd2Out BY user_b_id, Users BY user_id; 
Nbhd2OutUsers   = FOREACH Nbhd2OutUsers_1 GENERATE user_a_id AS user_a_id, user_b_id AS user_b_id, scraped_at AS scraped_at, Users::screen_name AS screen_name, protected AS protected, followers_count AS followers_count, friends_count AS friends_count, statuses_count AS statuses_count, favorites_count AS favorites_count, created_at AS created_at ;
STORE Nbhd2OutUsers INTO 'meta/datanerds/nbhd_2_out_users.tsv' ;

-- What would the signature of "This person is interesting but just talks too damn much?" be?

-- ===========================================================================
--
-- Get all the ancillary 
--

-- All tweets from people in the community
rm                             'meta/datanerds/n1_tweet.tsv' ;
N1Tweets_1              = JOIN  Nbhd1IDs      BY user_id, Tweets BY user_id PARALLEL 100;
N1Tweets                = FOREACH N1Tweets_1  GENERATE rsrc, tw_id, created_at, Tweets::user_id, favorited, truncated, repl_user_id, repl_tw_id, text, src ;
STORE N1Tweets            INTO 'meta/datanerds/n1_tweet.tsv' ;
N1Tweets                = LOAD 'meta/datanerds/n1_tweet.tsv'       AS (rsrc: chararray, tw_id: int, created_at: long, user_id: int, favorited: int, truncated: int, repl_user_id: int, repl_tw_id: int, text: chararray, src: chararray );

-- TwitterUsers for community
N1Users_1               = JOIN  Nbhd1IDs      BY user_id, Users BY user_id PARALLEL 100;
N1Users                 = FOREACH N1Users_1  GENERATE Users::rsrc, Users::user_id, scraped_at, screen_name, protected, followers_count, friends_count, statuses_count, favorites_count, created_at ;
STORE N1Users             INTO 'meta/datanerds/n1_user.tsv' ;
N1Users                 = LOAD 'meta/datanerds/n1_user.tsv'        AS (rsrc: chararray, user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favorites_count: int, created_at: long);

-- TwitterUserProfiles for community
N1UserProfiles_1        = JOIN  Nbhd1IDs      BY user_id, UserProfiles BY user_id PARALLEL 100;
N1UserProfiles          = FOREACH N1UserProfiles_1  GENERATE UserProfiles::rsrc, UserProfiles::user_id, scraped_at, full_name, url, location, description, time_zone, utc_offset;
STORE N1UserProfiles      INTO 'meta/datanerds/n1_user_profile.tsv' ;
N1UserProfiles          = LOAD 'meta/datanerds/n1_user_profile.tsv' AS (rsrc: chararray, user_id: int, scraped_at: long, full_name:   chararray, url: chararray, location: chararray, description: chararray, time_zone: chararray, utc_offset: int);

-- TwitterUserStyles for community
N1UserStyles_1          = JOIN  Nbhd1IDs      BY user_id, UserStyles BY user_id PARALLEL 100;
N1UserStyles            = FOREACH N1UserStyles_1  GENERATE UserStyles::rsrc, UserStyles::user_id, scraped_at, profile_background_color, profile_text_color, profile_link_color, profile_sidebar_border_color, profile_sidebar_fill_color, profile_background_tile, profile_background_image_url, profile_image_url;
STORE N1UserStyles        INTO 'meta/datanerds/n1_user_style.tsv' ;
N1UserStyles            = LOAD 'meta/datanerds/n1_user_style.tsv'  AS (rsrc: chararray, user_id: int, scraped_at: long, profile_background_color: chararray, profile_text_color: chararray, profile_link_color: chararray, profile_sidebar_border_color: chararray, profile_sidebar_fill_color: chararray, profile_background_tile: int, profile_background_image_url: chararray, profile_image_url: chararray);
