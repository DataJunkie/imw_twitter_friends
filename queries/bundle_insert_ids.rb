#!/usr/bin/env ruby
require 'fileutils'; include FileUtils
$: << File.dirname(__FILE__)+'/../lib'

require 'hadoop'
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/scrape'       ; include TwitterFriends::Scrape

class InsertIdsMapper <  Hadoop::Streamer
  def process context, *vals
    case
    when context == 'twitter_user_id'
      id, screen_name = vals
      screen_name ||= "!bogus-#{id}"
      puts [ screen_name.downcase, context, *vals ].join("\t")
    else
      screen_name = vals[1]
      puts [ screen_name.downcase, context, *vals ].join("\t")
    end
  end
end

class InsertIdsReducer < Hadoop::AccumulatingReducer
  attr_accessor :screen_name, :twitter_user_id, :scraped_contents
  def reset!
    super
    self.twitter_user_id  = nil
    self.scraped_contents = []
  end

  #
  # gather, for each screen name, the ID and all files' contents
  #
  def accumulate key, context, *vals
    self.screen_name = key
    case
    when context == 'twitter_user_id'
      self.twitter_user_id = vals[0]
    else
      self.twitter_user_id ||= vals[3] if (! vals[3].blank?)
      self.scraped_contents << [context, *vals]
    end
  end

  #
  # Detect inconsistent data
  #
  def all_numeric_screen_name?()   screen_name =~ /\A\d+\z/  end
  def bad_chars_in_screen_name?()  screen_name !~ /\A\w*[A-Za-z_]\w*\z/  end
  def missing_id?()                self.twitter_user_id.nil?  end
  def missing_screen_name?()       screen_name.blank? || (screen_name =~ /^!bogus-/) end

  #
  # Emit data bundled for actual parsing
  #
  def finalize
    case
    when missing_screen_name?      then context_prefix = 'bogus-no_screen_name-' ; return
    when all_numeric_screen_name?  then context_prefix = 'bogus-all_numeric-'    ; return
    when bad_chars_in_screen_name? then context_prefix = 'bogus-bad_chars-'      ; return
    when missing_id?               then context_prefix = 'bogus-missing_id-'     # ; return
    else                                context_prefix = ''
    end
    scraped_contents.each do |scraped_content|
      context, scraped_at, screen_name, page, id, *rest = scraped_content
      context = context_prefix + context
      id      = twitter_user_id if (! twitter_user_id.blank?)
      puts [context, scraped_at, id, page, screen_name, *rest].join("\t")
    end
  end
end


class InsertIdsStage2Script < Hadoop::Script
end
InsertIdsStage2Script.new(InsertIdsMapper, InsertIdsReducer).run

