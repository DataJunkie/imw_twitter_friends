
-- load data
AllFollowers 	= LOAD 'fixd/flattened/all/a_follows_b.tsv'  AS (rsrc: chararray, user_a_id: int,  user_b_id: int);
Users        	= LOAD 'fixd/flattened/all/twitter_user.tsv' AS (rsrc: chararray, user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favorites_count: int, created_at: long);
UserNames 	= FOREACH Users 	GENERATE id, screen_name ; 
-- Extract all users in the in or out 1-neighborhood
LocalNbhd_1  	= FILTER AllFollowers 	BY ((user_a_id == 1554031) OR (user_b_id == 1554031)) AND (user_a_id != 15045643) AND (user_b_id != 15045643) ;
LocalNbhdIds_1  = FOREACH LocalNbhd_1 	GENERATE user_a_id AS user_id;
LocalNbhdIds_2  = FOREACH LocalNbhd_1 	GENERATE user_b_id AS user_id;
LocalNbhdIds_3  = UNION LocalNbhdIds_1, LocalNbhdIds_2 ;
LocalNbhdIds    = DISTINCT LocalNbhdIds_3 ;

-- Find the in-2 and out-2 nbrhoods
NhdIn2_1       = JOIN 	 AllFollowers 	BY user_a_id, LocalNbhdIds by user_id ;
NhdIn2_2       = FILTER  NhdIn2_1 	BY user_id IS NOT NULL;
NhdIn2_3       = FOREACH NhdIn2_2 	GENERATE user_a_id AS user_a_id, user_b_id AS user_b_id ;
NhdOut2_1      = JOIN 	 AllFollowers 	BY user_b_id, LocalNbhdIds by user_id ;
NhdOut2_2      = FILTER  NhdOut2_1 	BY user_id IS NOT NULL;
NhdOut2_3      = FOREACH NhdOut2_2 	GENERATE user_a_id, user_b_id ;
Nhd2_1         = UNION NhdOut2_3, NhdIn2_3;
Nhd2           = DISTINCT Nhd2_1;


-- Attach screen names
Nhd2N_1        = JOIN Nhd2          	BY user_a_id, UserNames by user_id ; 
Nhd2N_2        = FOREACH Nhd2N_1    	GENERATE AllFollowers::user_a_id AS user_a_id, AllFollowers::user_b_id AS user_b_id, UserNames::screen_name AS user_a_name ;
Nhd2N_3        = JOIN    Nhd2N_2       	BY user_b_id, UserNames by user_id ; 
Nhd2N          = FOREACH Nhd2N_3    	GENERATE user_a_id AS user_a_id, user_b_id AS user_b_id, user_a_name AS user_a_name, UserNames::screen_name AS user_b_name ;
STORE Nhd2N INTO 'tmp/nbhds/local_2_pairs' ;


-- Expanded1Hd_b: {Expanded1Hd_a::LocalNbhd::rsrc: chararray,
--    Expanded1Hd_a::LocalNbhd::user_a: int,
--    Expanded1Hd_a::LocalNbhd::user_b: int,
--    Expanded1Hd_a::UserNames::id: int,
--    Expanded1Hd_a::UserNames::screen_name: chararray,
--    UserNames::id: int,
--    UserNames::screen_name: chararray}
Expanded1Hd = FOREACH Expanded1Hd_b GENERATE
  Expanded1Hd_a::LocalNbhd::user_a 	AS user_a_id,
  Expanded1Hd_a::LocalNbhd::user_b 	AS user_b_id,
  Expanded1Hd_a::UserNames::screen_name AS user_a_name,
  UserNames::screen_name 		AS user_b_name ;

STORE Expanded1Hd INTO 'tmp/nbhds/local_1_pairs' ;

-- ===========================================================================
--
-- Flatten into 1-hood
--
Local_1_out  = FILTER AllFollowers BY (user_a == 1554031) ;
Local_1_in   = FILTER AllFollowers BY (user_b == 1554031) ;




-- ===========================================================================
--
-- Generate 2-hood
--







-- ***************************************************************************
-- ***************************************************************************
--
-- Full Network
--
-- ***************************************************************************
-- ***************************************************************************

All2Hd_1 	= FOREACH AllFollowers 	GENERATE user_b_id AS mid, user_b_id AS user_c_id;
All2Hd_2	= JOIN 	  AllFollowers 	BY user_b_id, All2Hd_1 BY mid PARALLEL 60;
All2Hd 		= FOREACH All2Hd_2 	GENERATE user_a_id, user_b_id, user_c_id ;
STORE All2Hd INTO 'tmp/nbhds/all_2_pairs' ;


-- ===========================================================================
--
-- Flatten into 1-hood
--
