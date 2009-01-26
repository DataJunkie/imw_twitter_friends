
SELECT screen_name, context, page, twitter_user_id, priority FROM scrape_requests s 
WHERE scraped_at IS NOT NULL 
  AND result_code IS NULL
  AND priority <= -100
ORDER BY priority ASC, page 
INTO OUTFILE '~/ics/pool/social/network/twitter_friends/fixd/dump/scrape_requests_retries_20081215.tsv'


UPDATE scrape_requests req, scraped_file_index sfi
SET req.scraped_at = sfi.scraped_at,  req.result_code = IF(sfi.size=0, NULL, 200)
  WHERE	sfi.twitter_user_id = req.twitter_user_id
    AND 	sfi.context	 = req.context
    AND	sfi.page		= req.page
;    



select tup.id, tup.screen_name, tup.followers_count, tup.protected, u.screen_name, sr.* from
twitter_user_partials tup
LEFT JOIN twitter_users u ON u.id = tup.id
LEFT JOIN scrape_requests sr ON tup.id = sr.twitter_user_id
WHERE u.id IS NULL
LIMIT 10
;

select u.id, u.screen_name, u.followers_count, u.protected, sr.* from
twitter_users u, scrape_requests sr 
WHERE  u.id = sr.twitter_user_id
  AND sr.scraped_at IS NOT NULL
  AND sr.result_code IS NULL
ORDER BY priority ASC, context, page
LIMIT 1000
;

SELECT sr.*, sfi.*, u.* 
  FROM scrape_requests sr
  INNER JOIN	twitter_users u 		ON sr.twitter_user_id = u.id
  LEFT JOIN 	scraped_file_index sfi	ON sr.twitter_user_id = sfi.twitter_user_id AND sr.page = sfi.page AND sr.page = sfi.page
WHERE u.screen_name = 'BarackObama'
ORDER BY sr.twitter_user_id, sr.context, sr.page

-- ===========================================================================
--
-- Simple counts
--

SELECT
  @total_count:=(SELECT count(*) FROM twitter_users),
  statuses_count AS bin, 
  count(*) / @total_count AS pct, 
  count(*)       AS num
  FROM twitter_users u GROUP BY bin 

SELECT screen_name, id, statuses_count, followers_count, 
    ROUND(                  statuses_count / DATEDIFF(NOW(), created_at), 0) AS tweet_rate,
    ROUND(followers_count * statuses_count / DATEDIFF(NOW(), created_at), 0) AS outflux,
    DATE(u.created_at) AS day,
    DATEDIFF(NOW(), created_at) AS age,
    statuses_count + ROUND( 5 * 365 * (statuses_count / DATEDIFF(NOW(), created_at)), 0) AS num_in_5_yrs
  FROM     twitter_users u 
  WHERE    statuses_count > 1e5
  ORDER BY tweet_rate DESC
;

-- +-----------------+----------+----------------+-----------------+------------+---------+------------+------+--------------+
-- | screen_name     | id       | statuses_count | followers_count | tweet_rate | outflux | day        | age  | num_in_5_yrs |
-- +-----------------+----------+----------------+-----------------+------------+---------+------------+------+--------------+
-- | Market_JP       | 10812972 |        1560818 |               9 |       4140 |   37261 | 2007-12-03 |  377 |      9116502 |
-- | InternetRadio   |  8820362 |         592433 |            1671 |       1288 | 2152077 | 2007-09-11 |  460 |      2942847 |
-- | pawst           | 15500012 |         188356 |             511 |       1281 |  654761 | 2008-07-20 |  147 |      2526789 |
-- | nyhedsradar     | 15713425 |         159069 |             126 |       1196 |  150697 | 2008-08-03 |  133 |      2341783 |
-- | Aviongoo        | 15742447 |         121885 |              99 |        930 |   92112 | 2008-08-05 |  131 |      1819901 |
-- | xhtmlcss        | 10285992 |         337988 |              97 |        856 |   83000 | 2007-11-15 |  395 |      1899578 |
-- | exteenrecent    | 14121450 |         217354 |             528 |        782 |  412816 | 2008-03-11 |  278 |      1644228 |
-- | tv_prog_kansai  | 12177982 |         261284 |              49 |        778 |   38104 | 2008-01-13 |  336 |      1680460 |
-- | The_Time        | 15608218 |         102793 |             264 |        729 |  192463 | 2008-07-26 |  141 |      1433270 |
-- | ATNews          |  7380082 |         378500 |             264 |        724 |  191059 | 2007-07-10 |  523 |      1699270 |
-- | toss_garbage    | 15219769 |         111650 |              91 |        645 |   58729 | 2008-06-24 |  173 |      1289461 |
-- | bookmeter       | 15094007 |         117613 |             246 |        636 |  156394 | 2008-06-12 |  185 |      1277849 |
-- | emtemporeal     | 14801327 |         134029 |             192 |        632 |  121385 | 2008-05-16 |  212 |      1287816 |
-- | omankoxxx       | 10476452 |         230533 |               2 |        594 |    1188 | 2007-11-22 |  388 |      1314870 |
--
-- ....
-- 
-- +-----------------+----------+----------------+-----------------+------------+---------+------------+------+--------------+
-- 63 rows in set (1.39 sec)


-- ===========================================================================
--
-- string lengths
--

SELECT count(*)  INTO @total_count FROM twitter_users tc ;


SELECT  raw.bin, raw.num, TO_PERCENT(raw.num/@total_count) AS bin_pct, SUM(running.num) AS running_total, TO_PERCENT(SUM(running.num)/@total_count) AS running_pct
FROM    ( SELECT length(name) as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ) raw,
        ( SELECT length(name) as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ) running WHERE running.bin <= raw.bin GROUP BY raw.bin
        ;

SELECT  raw.bin, raw.num, TO_PERCENT(raw.num/@total_count) AS bin_pct, SUM(running.num) AS running_total, TO_PERCENT(SUM(running.num)/@total_count) AS running_pct
FROM    ( SELECT length(location) as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ) raw,
        ( SELECT length(location) as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ) running WHERE running.bin <= raw.bin GROUP BY raw.bin
        ;


-- NONBLANK	

SELECT count(*)  INTO @total_count                       FROM twitter_user_profiles tc ;
SELECT count(*)  INTO @blank_count                       FROM twitter_user_profiles tc WHERE( length(location) = 0 ) ;
SELECT "location hist" AS qname, raw.bin, raw.num,   TO_PERCENT(raw.num / @total_count)                         AS bin_pct,
  SUM(running.num) AS running_total,                 TO_PERCENT(SUM(running.num) / @total_count)                AS running_pct,
  SUM(running.num)-@blank_count AS nb_running_total, TO_PERCENT((SUM(running.num)-@blank_count) / @total_count) AS nb_running_pct
FROM    ( SELECT length(location) as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ) raw,
        ( SELECT length(location) as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ) running
  WHERE running.bin <= raw.bin GROUP BY raw.bin
;


-- ===========================================================================
-- screen_name
-- => 99.9% of screen_names are <15 chars
--
SELECT count(*)  INTO @total_count FROM twitter_user_partials tc ;
SELECT  raw.bin,
        raw.num,
  100*( raw.num          /  @total_count ) AS bin_pct,
        SUM(running.num)                   AS running_total,
  100*( SUM(running.num) /  @total_count ) AS running_pct
FROM    ( SELECT length(screen_name) as bin, count(*) as num FROM twitter_user_partials t GROUP BY bin ) raw,
        ( SELECT length(screen_name) as bin, count(*) as num FROM twitter_user_partials t GROUP BY bin ) running
  WHERE running.bin <= raw.bin
  GROUP BY raw.bin
;
-- +-----+--------+---------+---------------+-------------+
-- | bin | num    | bin_pct | running_total | running_pct |
-- +-----+--------+---------+---------------+-------------+
-- |   1 |     32 |  0.0015 |            32 |      0.0015 |
-- |   2 |    784 |  0.0358 |           816 |      0.0372 |
-- |   3 |  11276 |  0.5142 |         12092 |      0.5514 |
-- |   4 |  41065 |  1.8726 |         53157 |      2.4240 |
-- |   5 |  98081 |  4.4725 |        151238 |      6.8965 |
-- |   6 | 207218 |  9.4492 |        358456 |     16.3457 |
-- |   7 | 269704 | 12.2986 |        628160 |     28.6443 |
-- |   8 | 311579 | 14.2081 |        939739 |     42.8524 |
-- |   9 | 278502 | 12.6998 |       1218241 |     55.5521 |
-- |  10 | 283178 | 12.9130 |       1501419 |     68.4651 |
-- |  11 | 211197 |  9.6306 |       1712616 |     78.0958 |
-- |  12 | 172758 |  7.8778 |       1885374 |     85.9736 |
-- |  13 | 129769 |  5.9175 |       2015143 |     91.8911 |
-- |  14 |  96561 |  4.4032 |       2111704 |     96.2943 |
-- |  15 |  80404 |  3.6664 |       2192108 |     99.9607 |
-- |  16 |    439 |  0.0200 |       2192547 |     99.9808 |
-- |  17 |    192 |  0.0088 |       2192739 |     99.9895 |
-- |  18 |    143 |  0.0065 |       2192882 |     99.9960 |
-- |  19 |     87 |  0.0040 |       2192969 |    100.0000 |
-- +-----+--------+---------+---------------+-------------+
-- 19 rows in set (4.16 sec)
-- SELECT length(screen_name) AS bin, t.* FROM twitter_user_partials t WHERE length(screen_name) >= 20 ORDER BY bin ;

-- ===========================================================================
-- hashtag
-- 
--
SELECT count(*)  INTO @total_count FROM hashtags tc ;
SELECT  raw.bin,
        raw.num,
  100*( raw.num          /  @total_count ) AS bin_pct,
        SUM(running.num)                   AS running_total,
  100*( SUM(running.num) /  @total_count ) AS running_pct
FROM    ( SELECT length(hashtag) as bin, count(*) as num FROM hashtags t GROUP BY bin ) raw,
        ( SELECT length(hashtag) as bin, count(*) as num FROM hashtags t GROUP BY bin ) running
  WHERE running.bin <= raw.bin
  GROUP BY raw.bin
;

-- +-----+-------+---------+---------------+-------------+
-- | bin | num   | bin_pct | running_total | running_pct |
-- +-----+-------+---------+---------------+-------------+
-- |   2 |  7196 |  5.6048 |          7196 |      5.6048 |
-- |   3 | 12672 |  9.8699 |         19868 |     15.4746 |
-- |   4 | 25774 | 20.0746 |         45642 |     35.5492 |
-- |   5 | 14704 | 11.4525 |         60346 |     47.0017 |
-- |   6 | 18458 | 14.3764 |         78804 |     61.3781 |
-- |   7 | 10276 |  8.0037 |         89080 |     69.3818 |
-- |   8 |  8659 |  6.7442 |         97739 |     76.1261 |
-- |   9 |  7703 |  5.9996 |        105442 |     82.1257 |
-- |  10 |  5382 |  4.1919 |        110824 |     86.3176 |
-- |  11 |  4436 |  3.4551 |        115260 |     89.7726 |
-- |  12 |  3999 |  3.1147 |        119259 |     92.8874 |
-- |  13 |  2709 |  2.1100 |        121968 |     94.9973 |
-- |  14 |  1741 |  1.3560 |        123709 |     96.3533 |
-- |  15 |  1274 |  0.9923 |        124983 |     97.3456 |
-- |  16 |   903 |  0.7033 |        125886 |     98.0489 |
-- |  17 |   532 |  0.4144 |        126418 |     98.4633 |
-- |  18 |   448 |  0.3489 |        126866 |     98.8122 |
-- |  19 |   392 |  0.3053 |        127258 |     99.1175 |
-- |  20 |   236 |  0.1838 |        127494 |     99.3014 |
-- |  21 |   172 |  0.1340 |        127666 |     99.4353 |
-- |  22 |   185 |  0.1441 |        127851 |     99.5794 |
-- |  23 |    90 |  0.0701 |        127941 |     99.6495 |
-- |  24 |    64 |  0.0498 |        128005 |     99.6994 |
-- |  25 |    66 |  0.0514 |        128071 |     99.7508 |
-- |  26 |    43 |  0.0335 |        128114 |     99.7843 |
-- |  27 |    39 |  0.0304 |        128153 |     99.8146 |
-- |  28 |    41 |  0.0319 |        128194 |     99.8466 |
-- |  29 |    24 |  0.0187 |        128218 |     99.8653 |
-- |  30 |    20 |  0.0156 |        128238 |     99.8808 |
-- |  31 |    18 |  0.0140 |        128256 |     99.8949 |
-- |  32 |    21 |  0.0164 |        128277 |     99.9112 |
-- |  33 |    23 |  0.0179 |        128300 |     99.9291 |
-- |  34 |    12 |  0.0093 |        128312 |     99.9385 |
-- |  35 |    10 |  0.0078 |        128322 |     99.9463 |
-- |  36 |     6 |  0.0047 |        128328 |     99.9509 |
-- |  37 |    10 |  0.0078 |        128338 |     99.9587 |
-- |  38 |     3 |  0.0023 |        128341 |     99.9611 |
-- |  39 |    16 |  0.0125 |        128357 |     99.9735 |
-- |  40 |     5 |  0.0039 |        128362 |     99.9774 |
-- |  41 |     5 |  0.0039 |        128367 |     99.9813 |
-- |  42 |     3 |  0.0023 |        128370 |     99.9836 |
-- |  43 |     2 |  0.0016 |        128372 |     99.9852 |
-- |  44 |     4 |  0.0031 |        128376 |     99.9883 |
-- |  45 |     2 |  0.0016 |        128378 |     99.9899 |
-- |  48 |     1 |  0.0008 |        128379 |     99.9907 |
-- |  49 |     2 |  0.0016 |        128381 |     99.9922 |
-- |  50 |     1 |  0.0008 |        128382 |     99.9930 |
-- |  52 |     3 |  0.0023 |        128385 |     99.9953 |
-- |  53 |     1 |  0.0008 |        128386 |     99.9961 |
-- |  54 |     1 |  0.0008 |        128387 |     99.9969 |
-- |  57 |     1 |  0.0008 |        128388 |     99.9977 |
-- |  61 |     1 |  0.0008 |        128389 |     99.9984 |
-- |  66 |     1 |  0.0008 |        128390 |     99.9992 |
-- |  82 |     1 |  0.0008 |        128391 |    100.0000 |
-- +-----+-------+---------+---------------+-------------+


-- SELECT  raw.bin, raw.num, TO_PERCENT(raw.num/@total_count) AS bin_pct, SUM(running.num) AS running_total, TO_PERCENT(SUM(running.num)/@total_count) AS running_pct FROM    ( SELECT length(url) as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ) raw,         ( SELECT length(url) as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ) running WHERE running.bin <= raw.bin GROUP BY raw.bin;
-- +------+---------+---------+---------------+-------------+
-- | bin  | num     | bin_pct | running_total | running_pct |
-- +------+---------+---------+---------------+-------------+
-- |    0 | 1088666 | 66.3293 |       1088666 |     66.3293 |
-- |    1 |       3 |  0.0002 |       1088669 |     66.3295 |
-- |    2 |       1 |  0.0001 |       1088670 |     66.3295 |
-- |    3 |       1 |  0.0001 |       1088671 |     66.3296 |
-- |    5 |       1 |  0.0001 |       1088672 |     66.3297 |
-- |    6 |       3 |  0.0002 |       1088675 |     66.3298 |
-- |    7 |      54 |  0.0033 |       1088729 |     66.3331 |
-- |    8 |      28 |  0.0017 |       1088757 |     66.3348 |
-- |    9 |      21 |  0.0013 |       1088778 |     66.3361 |
-- |   10 |      40 |  0.0024 |       1088818 |     66.3386 |
-- |   11 |     540 |  0.0329 |       1089358 |     66.3715 |
-- |   12 |      74 |  0.0045 |       1089432 |     66.3760 |
-- |   13 |     366 |  0.0223 |       1089798 |     66.3983 |
-- |   14 |     896 |  0.0546 |       1090694 |     66.4529 |
-- |   15 |    1770 |  0.1078 |       1092464 |     66.5607 |
-- |   16 |    3143 |  0.1915 |       1095607 |     66.7522 |
-- |   17 |    5388 |  0.3283 |       1100995 |     67.0805 |
-- |   18 |    7928 |  0.4830 |       1108923 |     67.5635 |
-- |   19 |   11009 |  0.6707 |       1119932 |     68.2342 |
-- |   20 |   15107 |  0.9204 |       1135039 |     69.1547 |
-- |   21 |   20075 |  1.2231 |       1155114 |     70.3778 |
-- |   22 |   23664 |  1.4418 |       1178778 |     71.8196 |
-- |   23 |   26266 |  1.6003 |       1205044 |     73.4199 |
-- |   24 |   28646 |  1.7453 |       1233690 |     75.1652 |
-- |   25 |   31649 |  1.9283 |       1265339 |     77.0935 |
-- |   26 |   32300 |  1.9679 |       1297639 |     79.0614 |
-- |   27 |   33189 |  2.0221 |       1330828 |     81.0835 |
-- |   28 |   32639 |  1.9886 |       1363467 |     83.0721 |
-- |   29 |   32142 |  1.9583 |       1395609 |     85.0304 |
-- |   30 |   31418 |  1.9142 |       1427027 |     86.9447 |
-- |   31 |   29052 |  1.7701 |       1456079 |     88.7147 |
-- |   32 |   27117 |  1.6522 |       1483196 |     90.3669 |
-- |   33 |   24376 |  1.4852 |       1507572 |     91.8520 |
-- |   34 |   21817 |  1.3292 |       1529389 |     93.1813 |
-- |   35 |   19163 |  1.1675 |       1548552 |     94.3488 |
-- |   36 |   15940 |  0.9712 |       1564492 |     95.3200 |
-- |   37 |   13397 |  0.8162 |       1577889 |     96.1362 |
-- |   38 |   11179 |  0.6811 |       1589068 |     96.8174 |
-- |   39 |    8585 |  0.5231 |       1597653 |     97.3404 |
-- |   40 |    6767 |  0.4123 |       1604420 |     97.7527 |
-- |   41 |    5404 |  0.3293 |       1609824 |     98.0820 |
-- |   42 |    4555 |  0.2775 |       1614379 |     98.3595 |
-- |   43 |    3195 |  0.1947 |       1617574 |     98.5541 |
-- |   44 |    2723 |  0.1659 |       1620297 |     98.7200 |
-- |   45 |    2085 |  0.1270 |       1622382 |     98.8471 |
-- |   46 |    1739 |  0.1060 |       1624121 |     98.9530 |
-- |   47 |    1602 |  0.0976 |       1625723 |     99.0506 |
-- |   48 |    2802 |  0.1707 |       1628525 |     99.2213 |
-- |   49 |    1370 |  0.0835 |       1629895 |     99.3048 |
-- |   50 |     819 |  0.0499 |       1630714 |     99.3547 |
-- |   51 |     820 |  0.0500 |       1631534 |     99.4047 |
-- |   52 |     767 |  0.0467 |       1632301 |     99.4514 |
-- |   53 |     605 |  0.0369 |       1632906 |     99.4883 |
-- |   54 |     543 |  0.0331 |       1633449 |     99.5214 |
-- |   55 |     486 |  0.0296 |       1633935 |     99.5510 |
-- |   56 |     510 |  0.0311 |       1634445 |     99.5820 |
-- |   57 |     509 |  0.0310 |       1634954 |     99.6131 |
-- |   58 |     523 |  0.0319 |       1635477 |     99.6449 |
-- |   59 |     354 |  0.0216 |       1635831 |     99.6665 |
-- |   60 |     405 |  0.0247 |       1636236 |     99.6912 |
-- |   61 |     363 |  0.0221 |       1636599 |     99.7133 |
-- |   62 |     303 |  0.0185 |       1636902 |     99.7317 |
-- |   63 |     221 |  0.0135 |       1637123 |     99.7452 |
-- |   64 |     326 |  0.0199 |       1637449 |     99.7651 |
-- |   65 |     309 |  0.0188 |       1637758 |     99.7839 |
-- |   66 |     219 |  0.0133 |       1637977 |     99.7972 |
-- |   67 |     157 |  0.0096 |       1638134 |     99.8068 |
-- |   68 |     155 |  0.0094 |       1638289 |     99.8162 |
-- |   69 |     148 |  0.0090 |       1638437 |     99.8253 |
-- |   70 |     116 |  0.0071 |       1638553 |     99.8323 |
-- |   71 |     141 |  0.0086 |       1638694 |     99.8409 |
-- |   72 |     123 |  0.0075 |       1638817 |     99.8484 |
-- |   73 |     112 |  0.0068 |       1638929 |     99.8552 |
-- |   74 |     139 |  0.0085 |       1639068 |     99.8637 |
-- |   75 |     169 |  0.0103 |       1639237 |     99.8740 |
-- |   76 |     112 |  0.0068 |       1639349 |     99.8808 |
-- |   77 |      75 |  0.0046 |       1639424 |     99.8854 |
-- |   78 |      75 |  0.0046 |       1639499 |     99.8900 |
-- |   79 |      68 |  0.0041 |       1639567 |     99.8941 |
-- |   80 |      74 |  0.0045 |       1639641 |     99.8986 |
-- |   81 |      79 |  0.0048 |       1639720 |     99.9034 |
-- |   82 |     185 |  0.0113 |       1639905 |     99.9147 |
-- |   83 |     169 |  0.0103 |       1640074 |     99.9250 |
-- |   84 |      64 |  0.0039 |       1640138 |     99.9289 |
-- |   85 |      40 |  0.0024 |       1640178 |     99.9313 |
-- |   86 |      94 |  0.0057 |       1640272 |     99.9371 |
-- |   87 |      90 |  0.0055 |       1640362 |     99.9425 |
-- |   88 |      42 |  0.0026 |       1640404 |     99.9451 |
-- |   89 |      31 |  0.0019 |       1640435 |     99.9470 |
-- |   90 |      41 |  0.0025 |       1640476 |     99.9495 |
-- |   91 |      33 |  0.0020 |       1640509 |     99.9515 |
-- |   92 |      26 |  0.0016 |       1640535 |     99.9531 |
-- |   93 |      25 |  0.0015 |       1640560 |     99.9546 |
-- |   94 |      39 |  0.0024 |       1640599 |     99.9570 |
-- |   95 |      24 |  0.0015 |       1640623 |     99.9584 |
-- |   96 |      13 |  0.0008 |       1640636 |     99.9592 |
-- |   97 |      23 |  0.0014 |       1640659 |     99.9606 |
-- |   98 |      26 |  0.0016 |       1640685 |     99.9622 |
-- |   99 |      20 |  0.0012 |       1640705 |     99.9634 |
-- |  100 |     588 |  0.0358 |       1641293 |     99.9993 |
-- |  101 |       2 |  0.0001 |       1641295 |     99.9994 |
-- |  102 |       3 |  0.0002 |       1641298 |     99.9996 |
-- |  103 |       3 |  0.0002 |       1641301 |     99.9998 |
-- |  111 |       1 |  0.0001 |       1641302 |     99.9998 |
-- |  112 |       1 |  0.0001 |       1641303 |     99.9999 |
-- |  125 |       1 |  0.0001 |       1641304 |     99.9999 |
-- |  133 |       1 |  0.0001 |       1641305 |    100.0000 |
-- |  136 |       2 |  0.0001 |       1641307 |    100.0001 |
-- |  147 |       1 |  0.0001 |       1641308 |    100.0002 |
-- |  191 |       1 |  0.0001 |       1641309 |    100.0002 |
-- |  224 |       1 |  0.0001 |       1641310 |    100.0003 |
-- |  255 |       1 |  0.0001 |       1641311 |    100.0004 |
-- +------+---------+---------+---------------+-------------+
-- 112 rows in set, 36 warnings (6.42 sec)

  
-- ===========================================================================
--
-- Zipf Distributions
--

SELECT  raw.bin,  raw.utc_offset,
        raw.num,
  100*( raw.num          /  @total_count ) AS bin_pct,
        SUM(running.num)                   AS running_total,
  100*( SUM(running.num) /  @total_count ) AS running_pct
FROM    ( SELECT time_zone as bin, utc_offset, count(*) as num FROM twitter_user_profiles t GROUP BY bin, utc_offset ORDER BY num DESC) raw,
        ( SELECT time_zone as bin, utc_offset, count(*) as num FROM twitter_user_profiles t GROUP BY bin, utc_offset ORDER BY num DESC) running
  WHERE running.num >= raw.num
  GROUP BY raw.bin,  raw.utc_offset
  ORDER BY NUM DESC
  LIMIT 20
;

SELECT  raw.bin,
        raw.num,
  100*( raw.num          /  @total_count ) AS bin_pct,
        SUM(running.num)                   AS running_total,
  100*( SUM(running.num) /  @total_count ) AS running_pct
FROM    ( SELECT utc_offset as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ORDER BY num DESC) raw,
        ( SELECT utc_offset as bin, count(*) as num FROM twitter_user_profiles t GROUP BY bin ORDER BY num DESC) running
  WHERE running.num >= raw.num
  GROUP BY raw.bin
  ORDER BY NUM DESC
;

  
-- ===========================================================================
--
-- IDS in collection
--
-- this says more about our colxn than abt twitter,
-- certainly in the very slim fraction of tweets
--

SELECT MIN(created_at) FROM twitter_users u WHERE created_at > "2005" INTO @twitter_day_0 ;

SELECT MAX(id), LOG2(MAX(id))  FROM twitter_user_partials a ;
-- +----------+-----------------+
-- | MAX(id)  | LOG2(MAX(id))   |
-- +----------+-----------------+
-- | 18096295 | 24.109191017196 |
-- +----------+-----------------+

SELECT MAX(id), LOG2(MAX(id))  FROM tweets a ;
-- +------------+-----------------+
-- | MAX(id)    | LOG2(MAX(id))   |
-- +------------+-----------------+
-- | 1055069643 | 29.974691085425 |
-- +------------+-----------------+

SELECT 0.5*1e6   INTO @bin_size  ;
SELECT count(*) INTO @total_count FROM twitter_users  ;
SELECT raw.bin, raw.avg_age, raw.num,
  ROUND(100*( raw.num          /  @bin_size  ),4)   AS coverage,
  ROUND(100*( raw.num          /  @total_count ),2) AS bin_pct,
              SUM(running.num)                      AS running_total,
  ROUND(100*( SUM(running.num) /  @total_count ),2) AS running_pct
FROM    ( SELECT AVG(DATEDIFF(created_at,  @twitter_day_0)) AS avg_age,
                 @bin_size*CEILING(id / @bin_size) as bin, count(*) as num FROM twitter_users u GROUP BY bin ) raw,
        ( SELECT @bin_size*CEILING(id / @bin_size) AS bin, count(*) as num FROM twitter_users u GROUP BY bin ) running
  WHERE running.bin <= raw.bin
  GROUP BY raw.bin
;

-- +----------+----------+--------+----------+---------+---------------+-------------+
-- | bin      | avg_age  | num    | coverage | bin_pct | running_total | running_pct |
-- +----------+----------+--------+----------+---------+---------------+-------------+
-- |   500000 | 227.9102 |  13000 |   2.6000 |    0.79 |         13000 |        0.79 |
-- |  1000000 | 328.8406 |  28603 |   5.7206 |    1.74 |         41603 |        2.53 |
-- |  1500000 | 359.3585 |  10371 |   2.0742 |    0.63 |         51974 |        3.17 |
-- |  2000000 | 364.9304 |   9090 |   1.8180 |    0.55 |         61064 |        3.72 |
-- |  2500000 | 369.1615 |   8404 |   1.6808 |    0.51 |         69468 |        4.23 |
-- |  3000000 | 372.4889 |   7917 |   1.5834 |    0.48 |         77385 |        4.71 |
-- |  3500000 | 377.2822 |   8749 |   1.7498 |    0.53 |         86134 |        5.25 |
-- |  4000000 | 382.4659 |   8581 |   1.7162 |    0.52 |         94715 |        5.77 |
-- |  4500000 | 386.3928 |   8234 |   1.6468 |    0.50 |        102949 |        6.27 |
-- |  5000000 | 390.1089 |   6774 |   1.3548 |    0.41 |        109723 |        6.69 |
-- |  5500000 | 396.2282 |  12737 |   2.5474 |    0.78 |        122460 |        7.46 |
-- |  6000000 | 408.8140 |  27719 |   5.5438 |    1.69 |        150179 |        9.15 |
-- |  6500000 | 427.4175 |  26604 |   5.3208 |    1.62 |        176783 |       10.77 |
-- |  7000000 | 447.5259 |  25754 |   5.1508 |    1.57 |        202537 |       12.34 |
-- |  7500000 | 469.6555 |  26590 |   5.3180 |    1.62 |        229127 |       13.96 |
-- |  8000000 | 492.4807 |  25999 |   5.1998 |    1.58 |        255126 |       15.54 |
-- |  8500000 | 514.2149 |  23130 |   4.6260 |    1.41 |        278256 |       16.95 |
-- |  9000000 | 536.6657 |  22722 |   4.5444 |    1.38 |        300978 |       18.34 |
-- |  9500000 | 562.1824 |  24112 |   4.8224 |    1.47 |        325090 |       19.81 |
-- | 10000000 | 585.5082 |  23703 |   4.7406 |    1.44 |        348793 |       21.25 |
-- | 10500000 | 603.2784 |  23251 |   4.6502 |    1.42 |        372044 |       22.67 |
-- | 11000000 | 620.4309 |  20322 |   4.0644 |    1.24 |        392366 |       23.91 |
-- | 11500000 | 635.3962 |  21096 |   4.2192 |    1.29 |        413462 |       25.19 |
-- | 12000000 | 651.8125 |  18776 |   3.7552 |    1.14 |        432238 |       26.34 |
-- | 12500000 | 664.4541 |  20076 |   4.0152 |    1.22 |        452314 |       27.56 |
-- | 13000000 | 677.1514 |  20116 |   4.0232 |    1.23 |        472430 |       28.78 |
-- | 13500000 | 689.5429 |  21186 |   4.2372 |    1.29 |        493616 |       30.07 |
-- | 14000000 | 701.5328 |  20503 |   4.1006 |    1.25 |        514119 |       31.32 |
-- | 14500000 | 740.1908 | 213306 |  42.6612 |   13.00 |        727425 |       44.32 |
-- | 15000000 | 783.3086 | 203563 |  40.7126 |   12.40 |        930988 |       56.72 |
-- | 15500000 | 828.3944 | 185685 |  37.1370 |   11.31 |       1116673 |       68.04 |
-- | 16000000 | 869.3250 | 141970 |  28.3940 |    8.65 |       1258643 |       76.69 |
-- | 16500000 | 905.5865 | 123719 |  24.7438 |    7.54 |       1382362 |       84.22 |
-- | 17000000 | 936.7972 | 128972 |  25.7944 |    7.86 |       1511334 |       92.08 |
-- | 17500000 | 962.7008 |  86911 |  17.3822 |    5.30 |       1598245 |       97.38 |
-- | 18000000 | 980.7339 |  43054 |   8.6108 |    2.62 |       1641299 |      100.00 |
-- | 18500000 | 995.6667 |      6 |   0.0012 |    0.00 |       1641305 |      100.00 |
-- +----------+----------+--------+----------+---------+---------------+-------------+
-- 37 rows in set (5.11 sec)

SELECT 50*1e6   INTO @bin_size  ;
SELECT count(*) INTO @total_count FROM tweets  ;
SELECT raw.bin, raw.avg_age, raw.num,
  ROUND(100*( raw.num          /  @bin_size  ),4)   AS coverage,
  ROUND(100*( raw.num          /  @total_count ),2) AS bin_pct,
              SUM(running.num)                      AS running_total,
  ROUND(100*( SUM(running.num) /  @total_count ),2) AS running_pct
FROM    ( SELECT AVG(DATEDIFF(created_at,  @twitter_day_0)) AS avg_age,
                 @bin_size*CEILING(id / @bin_size) as bin, count(*) as num FROM tweets u GROUP BY bin ) raw,
        ( SELECT @bin_size*CEILING(id / @bin_size) AS bin, count(*) as num FROM tweets u GROUP BY bin ) running
  WHERE running.bin <= raw.bin
  GROUP BY raw.bin
;


-- +------------+----------+---------+----------+---------+---------------+-------------+
-- | bin        | avg_age  | num     | coverage | bin_pct | running_total | running_pct |
-- +------------+----------+---------+----------+---------+---------------+-------------+
-- |   50000000 | 366.6656 |   22509 |   0.0450 |    0.36 |         22509 |        0.36 |
-- |  100000000 | 428.3522 |   15376 |   0.0308 |    0.25 |         37885 |        0.61 |
-- |  150000000 | 463.3679 |   13202 |   0.0264 |    0.21 |         51087 |        0.82 |
-- |  200000000 | 494.3066 |   10214 |   0.0204 |    0.16 |         61301 |        0.98 |
-- |  250000000 | 521.3056 |    8330 |   0.0167 |    0.13 |         69631 |        1.11 |
-- |  300000000 | 544.6489 |    7860 |   0.0157 |    0.13 |         77491 |        1.24 |
-- |  350000000 | 568.4059 |    7872 |   0.0157 |    0.13 |         85363 |        1.36 |
-- |  400000000 | 588.2451 |    8807 |   0.0176 |    0.14 |         94170 |        1.50 |
-- |  450000000 | 607.1222 |    8734 |   0.0175 |    0.14 |        102904 |        1.64 |
-- |  500000000 | 624.9978 |    7791 |   0.0156 |    0.12 |        110695 |        1.77 |
-- |  550000000 | 640.9958 |    6705 |   0.0134 |    0.11 |        117400 |        1.88 |
-- |  600000000 | 657.5101 |    6475 |   0.0130 |    0.10 |        123875 |        1.98 |
-- |  650000000 | 671.0584 |    6366 |   0.0127 |    0.10 |        130241 |        2.08 |
-- |  700000000 | 684.8349 |    7333 |   0.0147 |    0.12 |        137574 |        2.20 |
-- |  750000000 | 698.3560 |    7104 |   0.0142 |    0.11 |        144678 |        2.31 |
-- |  800000000 | 745.0947 |   82960 |   0.1659 |    1.32 |        227638 |        3.64 |
-- |  850000000 | 802.7538 |  135175 |   0.2704 |    2.16 |        362813 |        5.79 |
-- |  900000000 | 863.5844 |  139344 |   0.2787 |    2.23 |        502157 |        8.02 |
-- |  950000000 | 911.4648 |  154405 |   0.3088 |    2.47 |        656562 |       10.49 |
-- | 1000000000 | 949.2317 |  234215 |   0.4684 |    3.74 |        890777 |       14.23 |
-- | 1050000000 | 987.0894 | 4217162 |   8.4343 |   67.35 |       5107939 |       81.58 |
-- | 1100000000 | 996.5990 | 1153235 |   2.3065 |   18.42 |       6261174 |      100.00 |
-- +------------+----------+---------+----------+---------+---------------+-------------+ -- 22 rows in set (28.33 sec)


SELECT      MIN(created_at)                      AS min_date,
  FROM_UNIXTIME(AVG(UNIX_TIMESTAMP(created_at))) AS avg_date,
  AVG(DATEDIFF(created_at,  @twitter_day_0))     AS avg_age,
           MAX(created_at)                       AS max_date,
  DATEDIFF(MAX(created_at), @twitter_day_0)      AS max_age
  FROM twitter_users u WHERE created_at > "2005" \G

-- min_date: 2006-03-21 20:50:14
-- avg_date: 2008-04-03 01:54:42
--  avg_age: 743.5300
-- max_date: 2008-12-12 15:01:32
--  max_age: 997

SELECT MIN(created_at) FROM twitter_users u WHERE created_at > "2005" INTO @twitter_day_0 ;
SELECT      MIN(created_at) 			 AS min_date,
  FROM_UNIXTIME(AVG(UNIX_TIMESTAMP(created_at))) AS avg_date,
  AVG(DATEDIFF(created_at, @twitter_day))  	 AS avg_age,
           MAX(created_at) 			 AS max_date,
  DATEDIFF(MAX(created_at), @twitter_day)        AS max_age,
  FROM tweets tw WHERE created_at > "2005" \G

-- min_date: 2006-04-29 01:35:52
-- avg_date: 2008-11-10 16:27:46
--  avg_age: 965.1568
-- max_date: 2008-12-13 09:37:03
--  max_age: 998
  
