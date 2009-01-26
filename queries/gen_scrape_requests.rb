#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/lib'

require 'hadoop'                       
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/scrape/scrape_request' ; include TwitterFriends::Scrape

#
# See bundle.sh for running pattern
#

module GenScrapeRequests
  class Mapper < Hadoop::StructStreamer
    attr_accessor :context
    def initialize *args
      super *args
      self.context = options[:context].to_sym
    end
    
    EXCLUDE_USERS = ['Oozzl', 'yobird'].to_set
    def exclude? user
      return true if EXCLUDE_USERS.include?(user.screen_name)
      case context
      when :favorites then return true if user.favourites_count.blank || (user.favourites_count.to_i <= 10)
      end
      false
    end
    
    #
    #
    def process user
      return unless user.is_a? TwitterUser
      return if exclude?(user)
      ScrapeRequest.requests_for_user(user, self.context).each do |scrape_request|
        scrape_request.priority = "%010d" % (1_000_000_000 - scrape_request.priority.to_i)
        puts scrape_request.output_form(false)
      end
    end

    #
    # Skip bogus records
    #
    def itemize line
      return if line =~ /^(?:bogus|bad_record)/
      super line
    end
  end

  class Reducer < Hadoop::StructStreamer
    def process scrape_request
      scrape_request.priority = "%010d" % (1_000_000_000 - scrape_request.priority.to_i)
      puts scrape_request.output_form(false)
    end
  end
  
  class Script < Hadoop::Script
    def sort_fields 
      5
    end

  end
end

GenScrapeRequests::Script.new(GenScrapeRequests::Mapper, GenScrapeRequests::Reducer).run
