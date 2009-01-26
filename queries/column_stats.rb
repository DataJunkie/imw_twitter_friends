#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../lib'

require 'hadoop'                       ; include Hadoop
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel

#
# See bundle.sh for running pattern
#

module ColumnStats
  class Mapper < Hadoop::StructStreamer
    #
    #
    def process thing
      rsrc = thing.resource_name
      thing.each_pair do |attr, val|
        puts [ "#{rsrc}-#{attr}", "%10d"%[val.to_s.length] ].join("\t")
      end
    end
  end

  class Script < Hadoop::Script
    def reduce_command
      '/usr/bin/uniq -c'
    end
  end
end

#
# Executes the script
#
ColumnStats::Script.new(ColumnStats::Mapper, nil).run
