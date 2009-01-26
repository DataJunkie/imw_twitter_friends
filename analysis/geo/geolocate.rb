#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'

require 'hadoop'                       ; include Hadoop
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel

#
# See bundle.sh for running pattern
#

module ExtractEntityPairs
  class Mapper < Hadoop::StructStreamer
    LOC_RE_IPHONE = %r{iPhone: (-?\d+\.\d+)\,(-?\d+\.\d+)}
    LOC_RE_COORDS = %r{(-?\d+\.\d+)\,\s*(-?\d+\.\d+)}
    LOC_RE_ZIP5   = %r{\b(\d{5})\b}
    LOC_RE_CITYST = %r{(.*),(.*)}

    def chunk_lat_lng lat, lng
      return unless lat && lng && lat.respond_to?(:to_f) && lng.respond_to?(:to_f)
      lat_chunk = 5*( ( 90 + lng.to_f)/5 ).round
      lng_chunk = 5*( (180 + lng.to_f)/5 ).round
      [lat_chunk, lng_chunk]
    end

    def dump_location user, context, loc_text, lat, lng, lat_chunk, lng_chunk
      puts ['loc' user.id, context, loc_text, lat, lng, lat_chunk, lng_chunk, user.utc_offset, user.time_zone].join("\t")
    end

    def clumsily_extract_location
      case
      when location.strip.empty?             then next;
      when m = LOC_RE_IPHONE.match(location) then ['iPhone', "#{$1},#{$2}", $1, $2 ]
      when m = LOC_RE_COORDS.match(location) then ['coords', "#{$1},#{$2}", $1, $2 ]
      when m = LOC_RE_CITYST.match(location) then ['named',  location]
      when m = LOC_RE_ZIP5.match(location)   then ['zip_5',  $1]
      else ['other', location]
      end
    end

    def process user
      return unless user.is_a?(TwitterUserProfile) || user.is_a?(TwitterUserPartial)
      # extract the location
      context, loc_text, lat, lng = clumsily_extract_location(user) or return
      # pre-calculate latitude and longitude 5-degree chunks,
      lat_chunk, lng_chunk = chunk_lat_lng lat, lng
      # emit it
      dump_location user, context, loc_text, lat, lng, lat_chunk, lng_chunk
    end
    #
    #

    #
    #
    def process tweet
      next unless tweet.is_a? Tweet
      entities = extract_entities(tweet.text) # note: !!not!! decoded_text, obvs.
      entities
    end
  end

  class Reducer < CountingReducer
  end

  class Script < Hadoop::Script
    # # want to pair on (user, entity) or (entity1, entity2)
    # def sort_fields
    #   2
    # end
  end
end

#
# Executes the script
#
ExtractEntityPairs::Script.new(
  # ExtractEntityPairs::Mapper,
  # ExtractEntityPairs::Reducer
  ).run



# function calcDist(lon1,lat1,lon2,lat2) {
#    var r = 3963.0;
#    var multiplier = 1;
#    return multiplier * r * Math.acos(Math.sin(lat1/57.2958) *
#            Math.sin(lat2/57.2958) +  Math.cos(lat1/57.2958) *
#            Math.cos(lat2/57.2958) * Math.cos(lon2/57.2958 -
#            lon1/57.2958));
# }:
