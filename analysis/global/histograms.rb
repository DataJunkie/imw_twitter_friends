#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'
require 'rubygems'
require 'active_support'

require 'wukong'                       ; include Wukong
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'wukong/and_pig'               ; include Wukong::AndPig
PIG_DEFS_DIR = File.dirname(__FILE__)+'/..'

# ===========================================================================
#
# Initialize
#
WORK_DIR = 'meta/global/histograms'
PigVar.default_path = WORK_DIR
Wukong::AndPig.init_load
# Make the TwitterUser class a friend of pig
TwitterUser.class_eval{ include PigEmitter }

#
# Find histograms
#
[
  [:created_at,       "(int)( (double)created_at / 1000000.0)"],
  # :followers_count,
  # :friends_count,
  # :favorites_count,
  # :statuses_count,

].each do |bin_attr, bin_expr|
  hist_rel = "#{bin_attr}_hist".to_sym
  TwitterUser[:twitter_user].histogram(hist_rel, bin_attr, bin_expr).store!
end


# TwitterUser[:twitter_user].histogram(:followers_count_hist, :followers_count).store!
