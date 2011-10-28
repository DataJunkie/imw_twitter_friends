-- load init_load.pig

-- AAtsignsB_1     = JOIN AAtsignsB_N BY user_b_name, Users BY screen_name PARALLEL 100;
-- AAtsignsB       = FOREACH AAtsignsB_1  GENERATE AAtsignsB_N::rsrc AS rsrc, user_a_id AS user_a_id, Users::user_id AS user_b_id, tw_id AS tw_id;
-- STORE AAtsignsB INTO 'fixd/rels/a_atsigns_b_i.tsv' ;
--
-- ARetweetsB_1    = JOIN ARetweetsB_N BY user_b_name, Users BY screen_name PARALLEL 100;
-- ARetweetsB      = FOREACH ARetweetsB_1 GENERATE ARetweetsB_N::rsrc AS rsrc, user_a_id AS user_a_id, Users::user_id AS user_b_id, tw_id AS tw_id, pls_flag AS pls_flag, text AS text ;
-- STORE ARetweetsB INTO 'fixd/rels/a_retweets_b_i.tsv' ;
AAtsignsB  = LOAD 'fixd/rels/a_atsigns_b_i.tsv'  AS (rsrc:  chararray, user_a_id: int, user_b_id: int, tw_id: int);
ARetweetsB = LOAD 'fixd/rels/a_retweets_b_i.tsv' AS (rsrc:  chararray, user_a_id: int, user_b_id: int, tw_id: int, pls_flag:int, text:chararray);

-- RelAt    = FOREACH AAtsignsB    GENERATE rsrc, user_a_id, user_b_id, tw_id ;
-- RelRT    = FOREACH ARetweetsB   GENERATE rsrc, user_a_id, user_b_id, tw_id ;
-- RelAFlwB = FOREACH AFollowsB    GENERATE rsrc, user_a_id, user_b_id, 0 AS tw_id ;
-- RelFav   = FOREACH AFavoritesB  GENERATE rsrc, user_a_id, user_b_id, tw_id ;
-- RelAll   = UNION RelAt, RelRT, RelFF, RelFav PARALLEL 58;
-- STORE RelAll INTO 'fixd/rels/all' ;
RelAll     = LOAD 'fixd/rels/all'                AS (rsrc:  chararray, user_a_id: int, user_b_id: int, tw_id: int);

EdgeCount_1 = GROUP RelAll BY (rsrc, user_a_id, user_b_id) PARALLEL 100;
EdgeCount   = FOREACH EdgeCount_1 GENERATE group.rsrc AS rsrc, group.user_a_id AS user_a_id, group.user_b_id AS user_b_id, COUNT(RelAll) AS freq;
STORE EdgeCount INTO 'fixd/rels/edge_count.tsv' ;
EdgeCount  = LOAD 'fixd/rels/edge_count.tsv'     AS (rsrc:  chararray, user_a_id: int, user_b_id: int, freq: int);


BFollowsA   = FOREACH AFollowsB GENERATE 'b_follows_a' AS  rsrc: chararray, user_b_id,      user_a_id;
STORE BFollowsA INTO 'fixd/rels/b_follows_a.tsv' ;
BFollowsA   = LOAD 'fixd/rels/b_follows_a.tsv'         AS (rsrc: chararray, user_a_id: int, user_b_id: int);

MutualFF_1   = UNION AFollowsB, BFollowsA PARALLEL 100 ;
MutualFF_2   = GROUP MutualFF_1 BY (user_a_id, user_b_id) PARALLEL 100;
MutualFF_3   = FOREACH MutualFF_2 GENERATE 'mutual_ff' AS rsrc:chararray, group.user_a_id AS user_a_id, group.user_b_id AS user_b_id, COUNT(MutualFF_1) AS freq;
MutualFF_4   = FILTER  MutualFF_3 BY freq == 2;
MutualFF     = FOREACH MutualFF_4 GENERATE 'mutual_ff' AS rsrc, user_a_id, user_b_id;

STORE MutualFF INTO 'fixd/rels/mutual_ff.tsv' ;
Mutual_FF   = LOAD 'fixd/rels/mutual_ff.tsv'         AS (rsrc: chararray, user_a_id: int, user_b_id: int);

-- EdgeWeight
