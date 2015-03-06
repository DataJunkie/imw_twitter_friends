
Approx. cardinality:
   8 068 820    twitter_user_partial.tsv # partial users as found in other users' tweets
   2 675 458    ... 		         ... giving info on 2675458 unique users
   2 173 417    twitter_user.tsv         # full user records
   2 168 569    twitter_user_profile.tsv
   2 168 739    twitter_user_style.tsv
     219 388    hashtag.tsv              # hashtags collected from tweets
  58 010 471    a_follows_b.tsv          # following relationships
  10 168 919    tweet.tsv                # unique tweets
   2 071 290    tweet_url.tsv            # urls collected from tweets
   2 997 735    a_atsigns_b.tsv          # all @atsigns collected from tweets (anywhere in tweet, but screen_name only and not threaded)
   2 494 807    a_replied_b.tsv          # @replies collected from tweets (only those that appear first, but threaded)
  90 542 155    total

(the user_partial thing: when you ask for a user's following / friends list, or
in the public timeline tweets, you get a partial listing of each user.  I've
kept, for these partial users, each unique state observed.  So if I was seen on
the 10th, the 15th, and the 16th and had (everything else the same) 80, 80 and
82 followers resp. you'll get the user_partial records of the 10th and the 16th
for me.)

===========================================================================

Layout of each file (all tab-delimited):

# class_name       [key_field] [scraped_at] ... attributes ...
TwitterUserPartial [:id],  :id,  :screen_name, :followers_count, :protected, :name, :url, :location, :description, :profile_image_url )
TwitterUser        [:id],  :id,  :screen_name, :created_at, :statuses_count, :followers_count, :friends_count, :favourites_count, :protected )
TwitterUserProfile [:id],  :id,  :name, :url, :location, :description, :time_zone, :utc_offset )
TwitterUserStyle   [:id],  :id,  :profile_background_color, :profile_text_color, :profile_link_color, :profile_sidebar_border_color, :profile_sidebar_fill_color, :profile_background_image_url, :profile_image_url, :profile_background_tile )
Tweet              [:id],  :id,  :created_at, :twitter_user_id, :text, :favorited, :truncated, :tweet_len, :in_reply_to_user_id, :in_reply_to_status_id, :fromsource, :fromsource_url )
AFollowsB          [:user_a_id, :user_b_id],               :user_a_id, :user_b_id  )
ARepliedB          [:user_a_id, :user_b_id,   :status_id], :user_a_id, :user_b_id,   :status_id, :in_reply_to_status_id )
AAtsignsB          [:user_a_id, :user_b_name, :status_id], :user_a_id, :user_b_name, :status_id ) # note we have no user_b_id for @foo
Hashtag            [:user_a_id, :hashtag],                 :user_a_id, :hashtag,     :status_id )
TweetUrl           [:user_a_id, :tweet_url],               :user_a_id, :tweet_url,   :status_id )

Pagerank files are
  user_id	pagerank	ids_that_user_follows
(and 'dummy' if we haven't gotten their follower list, or if that list is empty.)

=============================================================================
Notes:

* If you use the .tsv form make sure your language doesn't interpret the
  zero-padded twitter_user.id of '000000000072' as octal 58.

* I think that there may be inconsistent user data for all-numeric
  screen_name's: see
    http://code.google.com/p/twitter-api/issues/detail?id=162
  That is, I think that the data in this scrape may commingle information about
  the user having screen_name '415' with that of the user having id #415

* Watch out for some ill-formed screen_name's: see
    http://code.google.com/p/twitter-api/issues/detail?id=209

* For the parsed data: act as if I've double-checked none of this. If you
  have questions please ask, though.

* The scraped files (ripd-_xxxxxxxx.tar.bz2) *are* in their final form, and are
  exactly as they came off the server.

