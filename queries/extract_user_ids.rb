#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../lib'

require 'hadoop'                       ; include Hadoop
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel

#
# See bundle.sh for running pattern
#

module ExtractUserIds
  class Mapper < Hadoop::StructStreamer
    #
    #
    def process thing
      case
      when thing.is_a?(TwitterUser)
        user_id = TwitterUserId.new(thing.id, thing.screen_name, '1')
      when thing.is_a?(TwitterUserPartial) || thing.is_a?(TwitterUserId)
        user_id = TwitterUserId.new(thing.id, thing.screen_name, '0')
      when thing.respond_to?(:twitter_user_id)
        user_id = TwitterUserId.new(thing.twitter_user_id, '', '0')
      else return
      end
      puts user_id.output_form
    end
  end


  #
  # Collect all observations for a given id
  # If we see a screen name, capture it
  #   (assumes screen_name is constant, which it isn't)
  # If we see a full record, celebrate that fact
  #
  class Reducer < Hadoop::AccumulatingReducer
    attr_accessor :id, :screen_name, :full
    def reset!
      super
      self.id, self.screen_name, self.full = [nil, nil, nil]
    end
    def accumulate rsrc, id, screen_name, full
      self.id           ||= id
      self.screen_name  ||= screen_name  unless screen_name.blank?
      self.full = 1 if (full.to_i == 1)
    end
    def finalize
      self.full ||= 0
      key = "twitter_user_id-#{full}"
      puts [ key, id, screen_name, full ].join("\t")
    end
  end

  class Script < Hadoop::Script
  end
end

#
# Executes the script
#
ExtractUserIds::Script.new(ExtractUserIds::Mapper, ExtractUserIds::Reducer).run
