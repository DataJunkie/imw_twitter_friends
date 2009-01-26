
SELECT all_tweeted_urls INTO OUTFILE '/data/fixd/social/network/twitter_friends/dump/tweet_url_shorteneds-20081203.tsv'
  FROM  tweets
  WHERE all_tweeted_urls LIKE '%tinyurl.com%'
    OR  all_tweeted_urls LIKE '%is.gd%'
    OR  all_tweeted_urls LIKE '%snipurl.com%'
    OR  all_tweeted_urls LIKE '%snurl.com%'
    OR  all_tweeted_urls LIKE '%bit.ly%'
    OR  all_tweeted_urls LIKE '%ping.fm%'
    OR  all_tweeted_urls LIKE '%tr.im%'
    OR  all_tweeted_urls LIKE '%tiny.cc%'
    OR  all_tweeted_urls LIKE '%urlenco.de%'
    OR  all_tweeted_urls LIKE '%url.ie%'
