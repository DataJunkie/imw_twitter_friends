#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'json'
require 'active_support'
require 'imw' ; include IMW
require 'pathname'
# require 'imw/dataset/datamapper'
as_dset __FILE__

require 'hadoop_utils'
require 'twitter_flat_model'

raise "Please give a directory to load" unless ARGV[0]
LOAD_FILE_DIR = Pathname.new(ARGV[0]).realpath
DB_NAME = 'imw_twitter_graph'
def load_data_infile thing, fields, table=nil, line_prefix=nil
  line_prefix ||= thing
  table       ||= thing.to_s.pluralize
  query = %Q{
    LOAD DATA INFILE '#{LOAD_FILE_DIR}/#{thing}.tsv'
      REPLACE INTO TABLE        `#{DB_NAME}`.`#{table}`
      COLUMNS
        TERMINATED BY           '\\t'
        OPTIONALLY ENCLOSED BY  '"'
        ESCAPED BY              ''
      LINES STARTING BY         '#{line_prefix}\\t'
      (@dummy, #{fields.join(",")})
      ;
    SELECT '#{thing}', NOW(), COUNT(*) FROM `#{table}`;
  }
  $stdout.puts query
  $stdout.flush
end



$stderr.print "#{Time.now} - Loading"
[
  :a_atsigns_b           ,
  :a_replied_b           ,
  :hashtag               ,
  :tweet_url             ,
  :twitter_user_profile  ,
  :twitter_user_style    ,
  :twitter_user          ,
  :twitter_user_partial  ,
  :tweet                 ,
  :a_follows_b           ,
].each do |thing|
  klass = thing.to_s.camelize.constantize
  fields = klass.members
  fields[0]  = :twitter_user_id if [:twitter_user_profile, :twitter_user_style].include?(thing)
  case thing
  when :a_atsigns_b, :a_replied_b, :a_follows_b,
    :hashtag, :tweet_url, :tweet,
    :twitter_user_profile, :twitter_user_style
    fields.pop
  when :twitter_user, :twitter_user_partial
    fields[-1] = :scraped_at
  else raise "Don't know ass from hole in ground"
  end
  $stderr.print " -- #{thing}"
  #
  # emit mysql bulk loader query
  #
  load_data_infile thing, fields
end

# fields = TwitterUserPartial.members; fields[-1] = :scraped_at
# load_data_infile :twitter_user_partial, , :twitter_user_partial_all
