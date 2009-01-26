#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/lib'

require 'hadoop'
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/json_model'   ; include TwitterFriends::JsonModel

# rsrc=public_timeline ;
# hdp-rm -r fixd/$rsrc
# ./parse_json.rb --go --public_timeline rawd/bundled/$rsrc fixd/$rsrc/


#
#
# We only extract
# * user, user_partial, user_profile, and user_style;
# * tweet
# * a_follows_b, a_favorites_b
#
# All of the derived objects -- replies, @atsigns, hashtags, etc -- are done in
# the grokify pass.
#
module ParseJson
  class Mapper < Hadoop::Streamer
    # Map scrape context to parser class
    PARSER_FOR_CONTEXT = {
      'user'            => UserParser,
      'followers'       => FriendsFollowersParser,
      'friends'         => FriendsFollowersParser,
      'favorites'       => FriendsFollowersParser,
      'timeline'        => PublicTimelineParser,
      'user_timeline'   => PublicTimelineParser,
      'public_timeline' => PublicTimelineParser,
    }
    # user:     context, scraped_at, user_id,        page, screen_name, json_str
    # f/f/f:    context, scraped_at, owning_user_id, page, screen_name, json_str
    # p_t:      context, scraped_at, identifier,     page, moreinfo,    json_str

    #
    # Pass record to the parser
    # skipping bad records
    # finally, output serialized object
    #
    def process *args
      # context, scraped_at, identifier, page, moreinfo, json_str = args
      context, priority, identifier, page, moreinfo, url, scraped_at, *_ = args
      json_str = args.last
      return if context =~ /^bogus-/
      unless PARSER_FOR_CONTEXT[context]
        raise [args].flatten.join("\t")
      end
      parsed = PARSER_FOR_CONTEXT[context].new_from_json(json_str, context, scraped_at, identifier, page, moreinfo)
      unless parsed && parsed.healthy?
        bad_record!(context, scraped_at, identifier, page, moreinfo, json_str); return ;
      end
      #
      # output
      #
      parsed.each do |obj|
        puts obj.output_form
      end
    end
  end

  class Reducer < Hadoop::UniqByLastReducer
    def get_key item_key, *vals
      item_key
    end
  end

  class Script < Hadoop::Script
    #
    # Sort on <resource   id      scraped_at> (harmlessly using an extra field on immutable rows)
    #
    def sort_fields
      4
    end
  end
end

#
# Executes the script
#
ParseJson::Script.new(ParseJson::Mapper, ParseJson::Reducer).run
