#!/usr/bin/env bash

# all_base_files=fixd/user,fixd/friends,fixd/followers,fixd/favorites,fixd/public_timeline
# all_fixd_files="$all_base_files",fixd/text_elements

src_all_path="fixd/flattened/*.*"

query="$1"
src_path="${2-$src_all_path}"

if    [ "$query" == "" ] ; then
  echo "Need a query to run"
elif [ "$query" == "objects_frequency" ] ; then
  dest=metrics/$query
  hdp-rm -r $dest
  hdp-stream-flat "$src_path" "$dest" `realpath queries/objects_frequency-mapper.sh` '/usr/bin/uniq -c' -jobconf mapred.reduce.tasks=16
else
  echo "Don't know how to do query $query"
fi


#  74,491,199 a_follows_b
#  14,694,300 a_replies_b
#  17,508,797 a_atsigns_b
#     128,642 a_retweets_b
#   8,494,070 a_favorites_b
#   3,405,934 twitter_user
#   3,405,934 twitter_user_profile
#   3,405,934 twitter_user_style
#   3,790,411 twitter_user_partial
#  54,714,289 tweet
#   1,182,307 hashtag
#  12,520,605 tweet_url
