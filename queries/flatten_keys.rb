#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../lib'

require 'wukong'
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/json_model'   ; include TwitterFriends::JsonModel

# rsrc=public_timeline ;
# hdp-rm -r fixd/$rsrc
# ./parse_json.rb --go --public_timeline rawd/bundled/$rsrc fixd/$rsrc/


#
#
module KeyFlatten

  #
  # Optionally collapse the keyspace
  #
  # Note that this will make all of each resource stack up at one reducer:
  # if you have 60M frobnozz instances they will all land on the same machine.
  #
  class Mapper < Wukong::Streamer
    def stream
      $stdin.each do |line|
        line = line.chomp.gsub(/^(\w+)-[^\t]*\t/, "\\1\t")
        puts line
      end
    end
  end

  #
  class Script < Wukong::Script
    #
    # Sort on <key id timestamp>
    #
    def sort_fields
      3
    end
  end
end

#
# Executes the script
#
KeyFlatten::Script.new(KeyFlatten::Mapper, nil).run
