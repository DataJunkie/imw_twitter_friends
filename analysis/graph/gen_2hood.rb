#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'set'

#
# Characterize the 2-hood:
#
# * A flat list
#     user_a_id         <follower,follower,follower, ... > | <follower_of_follower,follower_of_follower,follower_of_follower,...>
#
# * Relation pairs
#   user_a_id   user_b_id    a_follows_b  b_follows_a   bothfollow   a_atsigns_b   b_atsigns_a   a_fol_fol_b   b_fol_fol_a
#   (a_fol_fol_b and a_follows_b are mutually exclusive, even if there are both direct and 2-step arcs from a to b.)
#
# * Local density
#   How many of my followers follow each other?

# ===========================================================================
# ==
# ==  Phase 1
# ==
#
# -------- map --------
#
# Start with the the flat 1hood-list :
#   < AA  |  B1, B2, B3, ... >
#
# For each B. emit both of
#   < B1  L  |  AA, B1, _   >
#   < AA  R  |  _,  AA, B1  >
#   < B2  L  |  AA, B2, _   >
#   < AA  R  |  _,  AA, B2  >
#   ...
#
# ------ reduce -------
#
# The reduce phase will aggregate the link halves impinging on each *middle*
# node and produce the set of two-links: given
#   < B1  L  |  AA, B1, _   >
#   < B1  L  |  CC, B1, _   >
#   < B1  L  |  DD, B1, _   >
#   < B1  R  |  _,  B1, AA  >
#   < B1  R  |  _,  B1, B2  >
#   < B1  R  |  _,  B1, CC  >
#
# we emit
#
#   < AA  2link  |  B1, AA  >  # (self-loop still needed for local density)
#   < AA  2link  |  B1, B2  >
#   < AA  2link  |  B1, CC  >
#   < CC  2link  |  B1, AA  >
#   < CC  2link  |  B1, B2  >
#   < CC  2link  |  B1, CC  >
#   < DD  2link  |  B1, AA  >
#   < DD  2link  |  B1, B2  >
#   < DD  2link  |  B1, CC  >
#   ...
#
# This gives an unsorted list of triplets, one for each two-step-long trip in
# the graph.

# ===========================================================================
# ==
# ==  Phase 2
# ==
#
# -------- map --------
#
# We use a nil map phase -- we want each starting node's keys grouped and
# sorted.
#
# ------ reduce -------
#
# The run for key A has all 2-edge paths that start at A:
#
#   < AA  2link  |  B1, AA  >
#   < AA  2link  |  B1, B2  >
#   < AA  2link  |  B1, CC  >
#   < AA  2link  |  B2, CC  >
#   < AA  2link  |  B2, DD  >
#   < AA  2link  |  B2, EE  >
#   ...
#
# Radius-2 nodes:
#
# * The union along the middle column gives the 1-hood again:
#     B1, B2, ...
# * The union along the right column gives all nodes that are 2 hops away:
#     B2, CC, DD, EE, ...
# * Removing the 1-hood nodes gives all the nodes at radius exactly 2:
#     CC, DD, EE, ...
#
# Local density:
# * Categorize each path by where it ends:
#   - at the origin (distance 0),
#   - at a node in the 1-hood (distance 1),
#   - or in the 2-hood (distance 2)
#   Emit the count of each category.
#

#
# Launch each relation as
#
#
def gen_2hood_mapper
  $stdin.each do |line|
    line.chomp!
    key, user_a_id, user_b_id, *rest = line.split "\t"
    warn "Ill-formed #{line}" if rest.empty?
    case key
    when 'a_follows_all'
      puts [user_a_id, 'a_follows_b', user_b_id].join("\t")
      puts [user_b_id, 'b_follows_a', user_a_id].join("\t")
    when 'both_follows'
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
when '--map'  then gen_1hood_mapper
when '--reduce' then gen_1hood_reducer
else raise "Need to specify an argument: --map, --reduce"
end
