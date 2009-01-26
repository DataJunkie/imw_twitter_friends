#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../../lib'

require 'hadoop'                       ; include Hadoop
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel

#
# See bundle.sh for running pattern
#

module ExtractEntityPairs
  class Mapper < Hadoop::StructStreamer
    def decimalize_entities text
      text = Hadoop.decode_str(text)
      Hadoop.html_encoder.encode(text, :decimal)
    end

    def extract_entities text
      # Strip out the boring, numerous punctuation entities
      text = text.gsub(/&(#10|#13|#9|apos|quot|amp|hellip|[lr]dquo|[rl]aquo|[nm]dash|[gl]t);/, '')
      # Let's just use decimal entities: more efficient in pig
      text = decimalize_entities(text)
      # raise if text =~ /&[^#\d]*;/
      entities = text.scan(/&#(\d+);/).flatten
    end

    def dump_single_entities entities
      entities.each do |entity_num|
        puts entity_num
      end
    end

    #
    # * emit (user_id, entity)  for counting
    #
    def dump_user_entity_pairs tweet, entities
      entities.each do |entity|
        puts [tweet.twitter_user_id, entity].join("\t")
      end
      # puts "%010d\t(%s)"[tweet.twitter_user_id, entities.join(',')]
    end

    #
    # for each entity:
    # * emit (entity1, entity2) for each unique pair of entities appearing in this tweet
    #
    # We *want* to repeat multiple entities and self-collocations:
    #   &foo;&bar;&foo;
    # should emit (&foo, &bar), (&foo, &foo), (&bar, foo)
    #
    def dump_entity_colloc entities
      tail  = entities.dup
      (1..entities.length).each do
        # pull off each entity
        entity1 = tail.shift
        # and emit a pair for all entities occurring after it in the string
        tail.each do |entity2|
          puts [entity1, entity2].join("\t")
        end
      end
    end

    #
    #
    def process tweet
      next unless tweet.is_a? Tweet
      entities = extract_entities(tweet.text) # note: !!not!! decoded_text, obvs.
      entities
    end
  end

  class SingleEntitiesMapper < Mapper
    def process tweet
      entities = super(tweet)
      dump_single_entities entities
    end
  end

  class CollocationsMapper < Mapper
    def process tweet
      entities = super(tweet)
      dump_entity_colloc(entities)
    end
  end

  class UserEntitiesMapper < Mapper
    def process tweet
      entities = super(tweet)
      dump_user_entity_pairs(tweet, entities)
    end
  end

  class Script < Hadoop::Script
    def initialize
      process_argv!
      case options[:mode]
      when 'single_entities' then self.mapper_klass  = SingleEntitiesMapper
      when 'user_entities'   then self.mapper_klass  = UserEntitiesMapper
      when 'collocations'    then self.mapper_klass  = CollocationsMapper
      else raise %Q{Please tell me what to emit:
        * --mode=single_entities to get a count of each individual entity
        * --mode=user_entities   to get a count of entities each user tweets
        * --mode=collocations    to get a count of entities that appear in same tweet
      }
      end
      self.reducer_klass = Reducer
    end

    # want to pair on (user, entity) or (entity1, entity2)
    def sort_fields
      2
    end
  end

  class Reducer < Hadoop::Streamer
    #
    #
    def sorting_by_freq_key freq
      logkey    = ( 10*Math.log10(freq) ).floor
      sort_log  = [1_000          -logkey,  1].max
      sort_freq = [1_000_000_000 - freq,    1].max
      "%03d\t%010d" % [sort_log, sort_freq]
    end

    def freq_key freq
      "%010d"%freq
    end

    def stream
      %x{/usr/bin/uniq -c}.split("\n").each do |line|
        freq, rest = line.chomp.strip.split(/\s+/, 2)
        freq = freq.to_i
        # next if freq <= 1
        puts [rest, freq_key(freq)].join("\t")
      end
    end
  end

end

#
# Executes the script
#
ExtractEntityPairs::Script.new(
  # ExtractEntityPairs::Mapper,
  # ExtractEntityPairs::Reducer
  ).run
