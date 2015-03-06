REPLACE INTO a_symmetric_bs (user_a_id, user_b_id, user_a_name, user_b_name)
  SELECT f1_id, f2_id, f1_name, f2_name
  FROM (
  SELECT 	afb.user_a_id AS f1_id, afb.user_a_name AS f1_name,
		afb.user_b_id AS f2_id, afb.user_b_name AS f2_name
    FROM a_follows_bs afb WHERE (afb.user_a_id >0) AND (afb.user_a_id < 20000) AND (afb.user_b_id >0) AND (afb.user_b_id < 20000)
  UNION ALL
  SELECT 	bfa.user_b_id AS f1_id, bfa.user_b_name AS f1_name,
		bfa.user_a_id AS f2_id, bfa.user_a_name AS f2_name
    FROM a_follows_bs bfa WHERE (bfa.user_a_id >0) AND (bfa.user_a_id < 20000) AND (bfa.user_b_id >0) AND (bfa.user_b_id < 20000)
  ) symm
  GROUP BY f1_id, f2_id HAVING COUNT(*) > 1 AND f2_id > f1_id

--
-- Symmetric link categorization
--
SELECT SUM(dir) as idx, f1, f2
  FROM (
  SELECT 1 AS dir, user_a_name AS f1, user_b_name AS f2 FROM a_follows_bs
    WHERE (user_a_name = 'mrflip') OR (user_b_name = 'mrflip')
  UNION ALL
  SELECT -1 AS dir, user_b_name AS f1, user_a_name AS f2 FROM a_follows_bs
    WHERE (user_a_name = 'mrflip') OR (user_b_name = 'mrflip')
  ) symm
  GROUP BY f1, f2
  ORDER BY f1, idx ASC


SELECT u.id,
	mx.prestige, mx.pagerank,
	u.created_at,
	u.followers_count, u.friends_count, u.statuses_count
   FROM 	twitter_users u, twitter_user_metrics mx
   WHERE 	mx.twitter_user_id = u.id
    AND 		u.followers_count > 1000
    AND		u.protected = 0
  ORDER BY	u.id


SELECT *
  FROM (SELECT u.id,
    pagerank, u.screen_name, u.followers_count, u.friends_count, u.statuses_count,
    ((1.07888 * LOG(followers_count))-18.14) AS pred_logrank, LOG(pagerank) AS logrank
   FROM 	twitter_users u, twitter_user_metrics mx
   WHERE 	mx.twitter_user_id = u.id
    AND 		u.followers_count > 500
    AND		u.protected = 0
  ORDER BY	mx.pagerank DESC) us
  WHERE ABS(pred_logrank-logrank) > 0.5


SELECT pred_logrank-logrank AS diff, us.*
  FROM (SELECT u.id, pagerank, u.screen_name, u.followers_count, u.friends_count, u.statuses_count,
  ((1.07888 * LOG(followers_count))-18.14) AS pred_logrank, LOG(pagerank) AS logrank
   FROM 	twitter_users u, twitter_user_metrics mx
   WHERE 	mx.twitter_user_id = u.id
    AND 		u.followers_count > 500
    AND		u.protected = 0) us
  WHERE ABS(pred_logrank-logrank) > 0.5
  ORDER BY	diff DESC


SELECT pred_logrank-logrank AS diff, us.*
  FROM (SELECT u.id, prestige, u.screen_name, u.followers_count,
  ((1.07888 * LOG(followers_count))-18.14) AS pred_logrank, LOG(pagerank) AS logrank
   FROM 	twitter_user_partials u, twitter_user_metrics mx
   WHERE 	mx.twitter_user_id = u.id
    AND 		u.followers_count > 500
    AND		u.protected = 0) us
  WHERE ABS(logrank - pred_logrank) > 0.5
  ORDER BY	diff DESC



