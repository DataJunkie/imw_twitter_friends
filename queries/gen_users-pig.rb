#!/usr/bin/env ruby
$: << File.dirname(__FILE__) + '/../../../wukong'
require 'wukong'
require 'wukong/and_pig' ; include Wukong::AndPig

HDFS_BASE_DIR = 'rawd/scrape_requests'
Wukong::AndPig::PigVar.working_dir = HDFS_BASE_DIR
Wukong::AndPig.comments    = false
# Wukong::AndPig.emit_dest   = :captured

Wukong::AndPig::PigVar.emit "REGISTER /usr/local/share/pig/contrib/piggybank/java/piggybank.jar"

#
# Load basic types
#

Wukong::AndPig::PigVar.emit %Q{
  TwitterUser         = LOAD 'fixd/flattened/twitter_user.tsv'                AS (rsrc: chararray, user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int, friends_count: int, statuses_count: int, favorites_count: int, created_at: long);
  TwitterUserPartial  = LOAD 'fixd/flattened/twitter_user_partial.tsv'        AS (rsrc: chararray, user_id: int, scraped_at: long, screen_name: chararray, protected: int, followers_count: int,
  Tweet               = LOAD 'fixd/flattened/tweet.tsv'                       AS (rsrc: chararray, tw_id: int,   created_at: long, user_id: int, favorited: int, truncated: int, repl_user_id: int, repl_tw_id: int, text: chararray, src: chararray );
}


def extract_ids users_list
  users_list.
    generate(:user_id, :followers_count).set!.
    order("followers_count DESC").set!
end

extract_ids :twitter_user

Wukong::AndPig.finish
