#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/lib'

require 'hadoop'                       ; include Hadoop
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/grok/grok_tweets'

#
# See bundle.sh for running pattern
#

module Grokify
  class Mapper < Hadoop::StructStreamer
    #
    # Extract semantic info from each object: (well, right now just from tweets):
    #  embedded urls,
    #  hashtags,
    #  re-tweets,
    #  replies,
    #  et cetera (see twitter_friends/grok/*)
    #
    def process thing
      return unless thing.is_a?(Tweet)
      thing.text_elements.each do |text_element|
        puts text_element.output_form
      end
    end
  end

  class Script < Hadoop::Script
    #
    # Use uniq program, not this script for reduce
    #
    def reduce_command
      '/usr/bin/uniq'
    end
  end
end

#
# Executes the script
#
Grokify::Script.new(Grokify::Mapper, nil).run
