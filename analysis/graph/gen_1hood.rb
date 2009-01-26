#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'set'

#
# Launch each relation towards each of its stakeholders,
# who will aggregate them in the +reduce+ phase
#
def gen_1hood_mapper
  $stdin.each do |line|
    line.chomp!
    key, item_key, user_a_id, user_b_id, *rest = line.split "\t"
    warn "Ill-formed #{line}" if rest.empty?
    case key
    when 'a_follows_b'
      puts [user_a_id, 'a_follows_b', user_b_id].join("\t")
      puts [user_b_id, 'b_follows_a', user_a_id].join("\t")
    when 'a_replied_b'
      puts [user_a_id, 'a_replied_b', user_b_id].join("\t")
      puts [user_b_id, 'b_replied_a', user_a_id].join("\t")
    else
      warn "Bad key in line #{line}"
    end
  end
end

# map relationships to integer codes
RELATIONSHIPS = [:a_follows_b, :b_follows_a, :a_atsigned_b, :bothfollow ]
#
#
#
def summarize_relations rels
  all_neighbors = Set.new
  rels.each{|rel, neighbors| all_neighbors = all_neighbors.merge(neighbors) }
  all_neighbors.map do |neighbor|
    [neighbor, RELATIONSHIPS.map{|rel| (rels[rel] && rels[rel].include?(neighbor)) ? 1 : 0 }]
  end
end

def dump_relation_summary user_a_id, rels
  summaries = summarize_relations(rels)
  summaries.each do |neighbor, summary|
    p ['all_rels', user_a_id, neighbor, *summary].join("\t")
  end
end

def find_bothfollow_links rels
  return unless rels[:a_follows_b]
  rels[:a_follows_b].intersection(rels[:b_follows_a])
end

def emit_relation_list kind, src, dests
  return if !dests || dests.empty?
  puts [kind, src, *dests].join("\t")
end

def dump_relation_lists user_a_id, rels
  emit_relation_list 'a_follows_all', user_a_id, rels[:a_follows_b]
  emit_relation_list 'all_follows_a', user_a_id, rels[:b_follows_a]
  emit_relation_list 'a_replied_all', user_a_id, rels[:a_replied_b]
  emit_relation_list 'all_replied_a', user_a_id, rels[:b_replied_a]
  emit_relation_list 'both_follows',  user_a_id, find_bothfollow_links(rels)
end

def setup_relations
  {
    :a_follows_b => Set.new,
    :b_follows_a => Set.new,
    :a_replied_b => Set.new,
    :b_replied_a => Set.new,
  }
end

def gen_1hood_reducer
  last_id = nil; rels = setup_relations
  $stdin.each do |line|
    line.chomp!
    user_a_id, relationship, user_b_id = line.split "\t"
    next unless user_b_id
    last_id ||= user_a_id
    if last_id == user_a_id
      #
      # accumulate all lines for a given ID
      #
      rels[relationship.to_sym] << user_b_id
      next
    else
      #
      # dispatch them for output.
      #
      dump_relation_lists   last_id, rels
      # dump_relation_summary last_id, rels
      #
      # Embark on a new relationships with this user
      #
      last_id = user_a_id
      rels = setup_relations
      rels[relationship.to_sym] << user_b_id
    end
  end
  dump_relation_lists   last_id, rels if last_id
end


case ARGV[0]
when '--map'    then gen_1hood_mapper
when '--reduce' then gen_1hood_reducer
else raise "Need to specify an argument: --map, --reduce"
end
