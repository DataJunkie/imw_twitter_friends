


UserMetrics = FOREACH TwitterUser GENERATE
  user_id: int, scraped_at: long, screen_name: chararray, protected: int,
  followers_count: int, friends_count: int, statuses_count: int, favorites_count: int, created_at: long,
  DATEDIFF(created_at, NOW()),

  friends_count / followers_count,

  ff_o_count  / day,
  ff_i_count  / day,
  ff_2_count  / day,
  at_o_count  / day,
  at_i_count  / day,
  rt_o_count  / day,
  rt_i_count  / day,
  ht_o_count  / day,
  ht_i_count  / day,
  lk_o_count  / day,
  lk_i_count  / day,
  tw_i_count  / day,
  tw_o_count  / day,
  fave_count  / day,  fave_count / in_tweet,



  last_tweet
  tweets_since
