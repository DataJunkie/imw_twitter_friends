#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/lib'

require 'hadoop'                       ; include Hadoop
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/rdf_output'

#
# See bundle.sh for running pattern
#

module Rdfify
  class Mapper < Hadoop::StructStreamer
    #
    # we need to reorder to
    #   subj pred timestamp pred
    # for correct sorting
    #
    # (this would be unnecessary with Hadoop 1.9 I hear)
    #
    def process thing
      thing.to_rdf3_tuples.each do |subj, obj, pred, timestamp|
        puts [subj, obj, timestamp, pred].join("\t")
      end
    end
  end

  # #
  # # We'd like to extract the *latest* value for each property
  # #
  # # Note especially that the scraped_at value thus holds the 'last time seen'
  # # for the **subject** (that is, the attribute and not its object).  For example, our
  # # last scrape might have yielded a TwitterUserPartial giving a new
  # # followers_count, while the statuses_count came from an earlier TwitterUser
  # # sighting.  The scraped_at value gives only the latest (partial user) date.
  # #
  # # Relationships are mutable, but for technical issues we can't count on seeing
  # # them disappear.
  # #
  # class Reducer < Hadoop::UniqByLastReducer
  # end

  class Script < Hadoop::Script
    def reduce_command
      '/usr/bin/uniq'
    end
  end
end

#
# Executes the script
#
Rdfify::Script.new(
  Rdfify::Mapper,
  nil # !!!!!!!!!!! note removed reducer, just straight uniq for nows.
  ).run
