#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'imw' ; include IMW
require 'imw/dataset/datamapper'
as_dset __FILE__
require 'fileutils'; include FileUtils
require 'scrape'
#
require 'twitter_graph_model'
require 'dm-aggregates'
require 'faster_csv'
require 'hadoop_utils'

#
# Setup database
#
# DataMapper.logging = true
dbparams = IMW::DEFAULT_DATABASE_CONNECTION_PARAMS.merge({ :dbname => 'imw_twitter_graph' })
DataMapper.setup_remote_connection dbparams

#
# Unravel old id's
#
class OldUser
  include DataMapper::Resource
  property   :old_id,                Integer, :key   => true
  property   :native_id,             Integer, :index => true
  property   :twitter_user_id,       Integer, :index => true
  property   :screen_name,           String,  :index => true, :length => 50
end
OldUser.auto_upgrade!

# INSERT IGNORE INTO imw_twitter_graph.old_users (old_id, native_id, screen_name)
#   SELECT id AS old_id, native_id, twitter_name AS screen_name
#     FROM imw_twitter_friends.twitter_users ou
# UPDATE imw_twitter_graph.old_users ou, imw_twitter_graph.twitter_user_partials u
#   SET ou.twitter_user_id = u.id
#   WHERE ou.screen_name = u.screen_name

#
# Tweet
#
class OldTweet
  include DataMapper::Resource
  property   :id,                    Integer, :key => true
  property   :created_at,            DateTime
  property   :twitter_user_id,       Integer
  property   :twitter_name,          String,  :length =>  50
  property   :text,                  String,  :length => 160
  property   :favorited,             Boolean
  property   :truncated,             Boolean
  property   :tweet_len,             Integer
  property   :in_reply_to_user_id,   Integer
  property   :in_reply_to_status_id, Integer
  property   :fromsource,            String, :length => 255
  property   :fromsource_url,        String, :length => 255
  property   :all_atsigns,           Text
  property   :all_hash_tags,         Text
  property   :all_tweeted_urls,      Text
  property   :scraped_at,            DateTime
  # Associations
  belongs_to :twitter_user
  has n,     :a_replied_b,                                     :child_key => [:status_id]
  has n,     :in_reply_tos,        :class_name => 'ARepliedB', :child_key => [:in_reply_to_status_id]
  has n,     :a_atsigns_b,                                     :child_key => [:status_id]
  has n,     :tweet_urls,                                      :child_key => [:status_id]
  has n,     :hashtags,                                        :child_key => [:status_id]
end
OldTweet.auto_upgrade!

def extract_hashtags old_tweet
  return if old_tweet.all_hash_tags == '[]'
  hashtags = JSON.load(old_tweet.all_hash_tags) or return
  hashtags.map do |hashtag|
    $hashtags_file << [
      old_tweet.twitter_user_id, hashtag, old_tweet.id,
      old_tweet.scraped_at.strftime("%Y-%m-%d %H:%M:%S")].to_tsv
  end
end

def extract_tweet_urls old_tweet
  return if old_tweet.all_tweeted_urls == '[]'
  tweet_urls = JSON.load(old_tweet.all_tweeted_urls) or return
  tweet_urls.map do |tweet_url|
    $tweet_urls_file << [
      old_tweet.twitter_user_id, tweet_url, old_tweet.id,
      old_tweet.scraped_at.strftime("%Y-%m-%d %H:%M:%S")].to_tsv
  end
end

def extract_atsigns old_tweet
  return if old_tweet.all_atsigns == '[]'
  atsigns = JSON.load(old_tweet.all_atsigns) or return
  atsigns.map do |atsign|
    $atsigns_file << [
      old_tweet.twitter_user_id, nil,
      nil,                       atsign,
      old_tweet.id, # status_id
      old_tweet.scraped_at.strftime("%Y-%m-%d %H:%M:%S")].to_tsv
  end
end

DUMP_DIR = 'fixd/dump'
$hashtags_file   = File.open(DUMP_DIR+'/all_hashtags_from_parsed_html.tsv',   "w")
$tweet_urls_file = File.open(DUMP_DIR+'/all_tweet_urls_from_parsed_html.tsv', "w")
$atsigns_file   = File.open(DUMP_DIR+'/all_atsigns_from_parsed_html.tsv', "w")

CHUNK_SIZE = 200
chunks = 2000 #  OldTweets.max( :id ) / CHUNK_SIZE
(2000..4000).each do |chunk|
  OldTweet.all(:id.gte => chunk*CHUNK_SIZE, :id.lt => (chunk+1)*CHUNK_SIZE).each do |old_tweet|
    track_count :tweets, 1000
    if !extract_hashtags(old_tweet).blank?   then track_count(:hashtags,   100) end
    if !extract_tweet_urls(old_tweet).blank? then track_count(:tweet_urls, 100) end
    if !extract_atsigns(old_tweet).blank?    then track_count(:atsigns,    100) end
  end
end

#
# SELECT id, datetime AS created_at, twitter_user_id,
#       content as `text`, NULL AS favorited, NULL AS truncated, LENGTH(content) AS tweet_len,
#       fromsource, fromsource_url,
#       inreplyto_name AS in_reply_to_user_id, inreplyto_tweet_id AS in_reply_to_status_id,
#       `all_atsigns`, `all_hashtags`, `all_tweet_urls`, datetime AS scraped_at
#   FROM         imw_twitter_friends.tweets
#   INTO OUTFILE '~/ics/pool/social/network/twitter_friends/fixd/dump/all_tweets_from_parsed_html.tsv' ;
#
