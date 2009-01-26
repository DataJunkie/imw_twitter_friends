-- TokenUsers_1         = LOAD 'meta/token_count/tokens' AS (rsrc: chararray,
--                context: chararray, user_id: int, token: chararray, usages: int);
-- TokenUsers           = FOREACH TokenUsers_1 GENERATE  user_id, token, usages;
-- 
-- TwTokenUsers_1       = FILTER TokenUsers BY context == 'tweet' ;
-- TwTokenUsers         = FOREACH TwTokenUsers_1 GENERATE  user_id, token, usages;
-- STORE TwTokenUsers    INTO 'meta/token_count/tw_tokens' ;

-- for now: only tweet stream, reduced corpus
TokenUsers_1    = LOAD 'meta/datanerds/token_count/tokens' AS (rsrc: chararray,
                                  context: chararray, user_id: int, token: chararray, usages: int);
TokenUsers      = FOREACH TokenUsers_1 GENERATE  user_id, token, usages;

TwTokenUsers_1  = FILTER TokenUsers BY context == 'tweet' ;
TwTokenUsers    = FOREACH TwTokenUsers_1 GENERATE  user_id, token, usages;
STORE TwTokenUsers    INTO 'meta/datanerds/token_count/tw_tokens' ;
TwTokenUsers      = LOAD 'meta/datanerds/token_count/tw_tokens' AS (user_id: int, token: chararray, usages: int);

-- ***************************************************************************
--   
-- Global totals
--
-- Each row in Tokens lists a (user, token, usages)
-- We want
--   Sum of all usage counts = total tokens seen in tweet stream.
--   Number of distinct tokens
--   Number of distinct users <- different than total in twitter_users.tsv
--                               because we want only users that say stuff.
--

TokUsers_1      = FOREACH TwTokenUsers GENERATE user_id   ;
TokUsers_2      = DISTINCT TokUsers_1 PARALLEL 10 ; 
TokUsers_3      = GROUP TokUsers_2 ALL ;
NTokUsers       = FOREACH TokUsers_3 GENERATE COUNT(TokUsers_2.user_id) ;
STORE NTokUsers   INTO 'meta/datanerds/token_count/n_tok_users' ;
NTokUsers       = LOAD 'meta/datanerds/token_count/n_tok_users' AS (n_tok_users);
-- 436


TokTokens_1          = FOREACH TwTokenUsers GENERATE token   ;
TokTokens_2          = DISTINCT TokTokens_1 PARALLEL 10 ; 
TokTokens_3          = GROUP TokTokens_2 ALL ;
NTokTokens           = FOREACH TokTokens_3 GENERATE COUNT(TokTokens_2.token) ;
STORE NTokTokens       INTO 'meta/datanerds/token_count/n_tok_tokens' ;
NTokTokens           = LOAD 'meta/datanerds/token_count/n_tok_tokens' AS (n_tok_users);
-- 61630

-- ***************************************************************************
--   
-- Statistics for each user
--

UserToksFlat_1	= GROUP TwTokenUsers BY user_id ;
UserToksFlat_2    = FOREACH UserToksFlat_1 {
  tot_tokens 	= (int)COUNT(TwTokenUsers) ;
  tot_usages    = (int)SUM(TwTokenUsers.usages) ;
  GENERATE group AS user_id, tot_tokens AS tot_tokens, tot_usages AS tot_usages, FLATTEN(TwTokenUsers.(token, usages) ) AS (token, usages);
}
UserToksFlat   = FOREACH UserToksFlat_2 GENERATE user_id, token, usages, (float)(1.0*usages / tot_usages) AS usage_pct
STORE UserToksFlat INTO 'meta/datanerds/token_count/user_toks_flat' ;
UserToksFlat     = LOAD 'meta/datanerds/token_count/user_toks_flat' AS (user_id: int,token: chararray,usages: int,usage_pct: float) ;


-- ***************************************************************************
--   
-- Statistics for each token
--
-- Note that the line   tot_users = (int)COUNT(UserToksFlat) ;
-- is correct: we're counting the *alias*, one per each user.


TokenStats_1	= GROUP UserToksFlat BY token ;
TokenStats_2    = FOREACH TokenStats_1 {
  tot_users 	= (int)COUNT(UserToksFlat) ;
  tot_usages    = (int)SUM(UserToksFlat.usages) ;
  GENERATE group AS user_id, tot_tokens AS tot_tokens, tot_usages AS tot_usages, FLATTEN(UserToksFlat.(token, usages) ) AS (token, usages);
}
TokenStats   = FOREACH TokenStats_2 GENERATE user_id, token, usages, (float)(1.0*usages / tot_usages) AS usage_pct
STORE TokenStats INTO 'meta/datanerds/token_count/token_stats' ;
TokenStats     = LOAD 'meta/datanerds/token_count/token_stats' AS (user_id: int,token: chararray,usages: int,usage_pct: float) ;


TokenCounts_1    = FOREACH TwTokens GENERATE user_id, token, usages, (1.0*usages*usages) AS usages_sq;
TokenCounts_2    = GROUP   TokenCounts_1 BY token PARALLEL 100;
TokenCounts_3    = FOREACH TokenCounts_2 {
  usages_var    = AVG(TokenCounts_1.usages_sq) - (AVG(TokenCounts_1.usages) * AVG(TokenCounts_1.usages));
  usages_avg    = AVG(TokenCounts_1.usages);
  usages_tot    = (int)SUM(  TokenCounts_1.usages);
  usages_ppm    = (long)usages_tot / (352661169.0 / 1000000.0)
  GENERATE group                         AS token,
           'tokens'                       AS user_id,
            AS usages:     int,
           (int)COUNT(TokenCounts_1)      AS range:    int,
           (float)usages_var             AS usages_var: float,
           (float)usages_avg             AS usages_avg: float;
  };
  
TokenCounts        = ORDER TokenCounts BY context ASC, usages DESC PARALLEL 100; 
STORE TokenCounts    INTO 'meta/token_count/token';
TokenCounts        = LOAD 'meta/token_count/token' AS (context: chararray, user_id: int, token: chararray, usages: int);

-- Range is how many people used the token

-- Dispersion is Julliand's D
-- 
--               V
-- D = 1 - ---------------
--           sqrt(n - 1)
-- 
-- V = s / x
--        
-- Where
-- 
-- * n is the number of users
-- * s is the standard deviation of the subusagesuencies
-- * x is the average of the subusagesuencies
--

-- TokenCounts_1: {
--   group:  (context: chararray,token: chararray),
--   Tokens: {rsrc:chararray,context: chararray,user_id: int,token: chararray,usages: int}}

-- GlobalUsages_1       = FOREACH Tokens GENERATE context, user_id, token, usages, (1.0*(float)usages*(float)usages) AS usages_sq:float;
-- GlobalUsages_2       = GROUP   GlobalUsages_1 BY (context);
-- GlobalUsages = FOREACH GlobalUsages_2 {
--   usages_sum_sq = AVG(GlobalUsages_1.usages_sq)
--   usages_avg    = AVG(GlobalUsages_1.usages);
--   GENERATE group              AS context,
--         'total'               AS user_id,
--         (int)SUM(  GlobalUsages_1.usages) AS usages:  int,
--         (float)usages_sum_sq             AS usages_var: float,
--         (float)usages_avg                AS usages_avg: float;
--   };
-- loc          total     1915556         1909935         0.00313       1.002943
-- name         total     3525910         3524825         0.00034       1.000308
-- desc         total     5170618         4971975         0.05483       1.039953
-- tweet        total   352661169       185403045       144.00517       1.902133
