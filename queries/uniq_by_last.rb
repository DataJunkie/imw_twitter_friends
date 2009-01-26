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
module Uniqify

  class Reducer < Wukong::UniqByLastReducer
    def get_key item_key, *vals
      item_key
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
Uniqify::Script.new(nil, Uniqify::Reducer).run
