Tokens = LOAD 'meta/word_counts/tokens' AS (rsrc: chararray,
  context: chararray, owner: int, word: chararray, freq: int);

-- ***************************************************************************
--   
-- Global totals
--
TotalFreq_1 	= FOREACH Tokens GENERATE context, owner, word, freq, (1.0*(float)freq*(float)freq) AS freq_sq:float;
TotalFreq_2 	= GROUP   TotalFreq_1 BY (context);


TotalFreq	= FOREACH TotalFreq_2 {
  freq_var    = AVG(TotalFreq_1.freq_sq) - (AVG(TotalFreq_1.freq) * AVG(TotalFreq_1.freq));
  freq_avg    = AVG(TotalFreq_1.freq);
  GENERATE group 		 AS context,
   	   'total' 		 AS owner,
	   (int)SUM(  TotalFreq_1.freq) AS freq:  int,
	   (int)COUNT(TotalFreq_1)      AS range: int,
	   (float)freq_var 	        AS freq_var: float,
	   (float)freq_avg 	        AS freq_avg: float;
  };


-- loc  	total	  1915556	  1909935	  0.00313	1.002943
-- name 	total	  3525910	  3524825	  0.00034	1.000308
-- desc 	total	  5170618	  4971975	  0.05483	1.039953
-- tweet	total	352661169	185403045	144.00517	1.902133

-- ***************************************************************************
--   
-- Extract just tweets
--

TwTokens_1 = FILTER Tokens BY context == 'tweet' ;
TwTokens   = FOREACH TwTokens_1 GENERATE  owner, word, freq;
STORE TwTokens INTO 'meta/word_counts/tweet_toks' ;
TwTokens   = LOAD 'meta/word_counts/tokens' AS (owner: int, word: chararray, freq: int);

-- ***************************************************************************
--   
-- Statistics for each word
--

WordCounts_1 	= FOREACH TwTokens GENERATE owner, word, freq, (1.0*freq*freq) AS freq_sq;
WordCounts_2 	= GROUP   WordCounts_1 BY word PARALLEL 100;
WordCounts_3	= FOREACH WordCounts_2 {
  freq_var    = AVG(WordCounts_1.freq_sq) - (AVG(WordCounts_1.freq) * AVG(WordCounts_1.freq));
  freq_avg    = AVG(WordCounts_1.freq);
  freq_tot    = (int)SUM(  WordCounts_1.freq);
  freq_ppm    = (long)freq_tot / (352661169.0 / 1000000.0)
  GENERATE group 	 		 AS word,
   	   'words' 			 AS owner,
	    AS freq:     int,
	   (int)COUNT(WordCounts_1)      AS range:    int,
	   (float)freq_var 	         AS freq_var: float,
	   (float)freq_avg 	         AS freq_avg: float;
  }
  
WordCounts        = ORDER WordCounts BY context ASC, freq DESC PARALLEL 100; 
STORE WordCounts    INTO 'meta/word_counts/word';
WordCounts        = LOAD 'meta/word_counts/word' AS (context: chararray, owner: int, word: chararray, freq: int);

-- Range is how many people used the word

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
-- * s is the standard deviation of the subfrequencies
-- * x is the average of the subfrequencies
--

-- WordCounts_1: {
--   group:  (context: chararray,word: chararray),
--   Tokens: {rsrc:chararray,context: chararray,owner: int,word: chararray,freq: int}}
