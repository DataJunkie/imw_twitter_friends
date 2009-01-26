#!/usr/bin/env ruby
require 'rubygems'
require 'dm-core'
require 'imw/utils'
require 'imw/dataset/datamapper'
require 'JSON'
require 'activesupport'
include IMW; IMW.verbose = true
as_dset __FILE__

require 'imw/dataset/stats/counter'
DataMapper::Logger.new(STDOUT, :warn)

#
# Setup database
#
require 'twitter_friends_db_definition'; setup_twitter_friends_connection()
require 'twitter_profile_model'

class GraphDumper
  attr_reader :file_format
  def initialize
    @dump_file = nil
  end
  def dump_file file_base, &block
    @dump_file ||= File.open("#{file_base}.#{self.file_format}",'w')
  end
end

class XGMMLDumper < GraphDumper
  def header()
    %Q{<?xml version="1.0"?>}
  end
  def graph_open()
    %Q{
  <graph directed='1' Rootnode='1'
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:ns1="http://www.w3.org/1999/xlink"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns="http://www.cs.rpi.edu/XGMML">}
  end
  def graph_end()  "\n</graph>" end
end

class SIFDumper < GraphDumper
  def initialize
    super
    @file_format = :sif
  end
  def header()       ''  end
  def graph_open()   ''  end
  def graph_end()    ''  end
  def dump_relationship from, to, edge_type=:to
    @dump_file << "#{from} #{edge_type} #{to}\n"
  end
  def dump_node node
    # pass
  end
end

class TwitterGraph
  attr_accessor :users_seen
  def initialize
    self.users_seen = RecordCounter.new
  end
  CHUNK_SIZE   = nil
  MAX_CHUNKS   = 1
  def dump_graph graph_file_base
    dumper = SIFDumper.new()
    dumper.dump_file(path_to(graph_file_base))
    announce "beginning friendship dump"
    Friendship.all_by_chunks(CHUNK_SIZE, MAX_CHUNKS) do |f|
      # users_seen.unless_seen([:user, friend_id]  ){ dumper.dump_node(friend_id)   }
      # users_seen.unless_seen([:user, follower_id]){ dumper.dump_node(follower_id) }
      dumper.dump_relationship f.follower_id, f.friend_id, :flw
    end
    # User.all_by_chunks do |user|
    #   users_seen.unless_seen(user){ dumper.dump_node(user.id) }
    #   user.friendships.each do |friendship|
    #     dumper.dump_relationship friendship.friend_id, user.id, :flw
    #   end
    # end
    announce "end #{users_seen.length} seen"
  end
end

class Friendship < Fiddle
  def to_xgmml
    %Q{
    <edge label="f" source="#{follower_id}" target="#{friend_id}"></edge>}
  end
  #
  # uses an efficient query to dump a massive load
  #
  def self.all_by_sql limits, &block
    query = all_by_sql_query limits
    announce query
    repository(:default).adapter.query(query).each do |friendship_struct|
      yield friendship_struct.to_a
    end
  end
  def self.all_by_sql_query limits
    %Q{
      SELECT F.follower_id, F.friend_id,
             follower.twitter_name AS follower_name,
             friend.twitter_name   AS friend_name
        FROM       friendships F
        RIGHT JOIN  users friend   ON F.friend_id   = friend.id
        RIGHT JOIN  users follower ON F.follower_id = follower.id
      WHERE (friend.followers_count   > 30) AND (follower.followers_count > 60)
      LIMIT #{limits.first}, #{limits.last}
    }
  end
end

# id name label labelanchor edgeanchor weight
class User < Fiddle
  def to_xgmml_big
   #      <att name="tw_title"              value="#{real_name}"/>
    %Q{
    <node id="#{id}" name="#{twitter_name}" label="#{twitter_name}" weight="#{followers_count||0}">
      <att name="tw_following_count"    value="#{following_count||0}"/>
      <att name="tw_followers_count"    value="#{followers_count||0}"/>
      <att name="tw_updates_count"      value="#{updates_count||0}"/>
      <att name="tw_photo"              value="#{style_mini_img_url}"/>
      <att name="tw_last_seen"          value="#{last_seen_update_time}"/>
      <att name="tw_twitter_id"         value="#{twitter_id}"/>
    </node>}
  end
  def to_xgmml
    %Q{
    <node id="#{id}" name="#{twitter_name}" label="#{twitter_name}"></node>}
  end
end

TwitterGraph.new.dump_graph [:fixd, 'graphs/testing']
