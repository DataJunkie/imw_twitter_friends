#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'set'
require 'pathname'

#
# Launch each relation towards each of its stakeholders,
# who will aggregate them in the +reduce+ phase
#
def gen_initial_pagerank_graph_mapper
  $stdin.each do |line|
    line.chomp!
    key, item_key, scraped_at, user_a_id, user_b_id, *rest = line.split "\t"
    warn "Ill-formed #{line}"      if user_b_id.empty?
    puts [user_a_id, key, user_b_id].join("\t")
  end
end


# emit relationship for heretrix pagerank code
def emit_initial_pagerank src, dests
  if !dests || dests.empty?
    dests = ['dummy']
  end
  destlist = dests.join(",") 
  puts [src, 1.0, destlist].join("\t")
end


def gen_initial_pagerank_graph_reducer
  last_id = nil; rels = []
  $stdin.each do |line|
    line.chomp!
    user_a_id, relationship, user_b_id = line.split("\t").map{|s| s.strip }
    next unless user_b_id
    last_id ||= user_a_id
    if last_id == user_a_id
      #
      # accumulate all lines for a given ID
      #
      rels << user_b_id
      next
    else
      #
      # dispatch them for output.
      #
      emit_initial_pagerank last_id, rels
      #
      # Embark on a new relationships with this user
      #
      last_id = user_a_id
      rels = []
      rels << user_b_id
    end
  end
  emit_initial_pagerank last_id, rels if last_id
end

case ARGV[0]
when '--map'    then gen_initial_pagerank_graph_mapper
when '--reduce' then gen_initial_pagerank_graph_reducer
when '--runme'  then 
  slug = Time.now.strftime("%Y%m%d")
  input_files, output_dir = ARGV[1..2]
  raise "You need to specify a parsed input directory and a directory for the initial pagerank file: got #{ARGV.inspect}" if input_files.empty? || output_dir.empty?
  mapred_script = Pathname.new(__FILE__).realpath
  dummy_file    = File.dirname(mapred_script)+'/dummy_pagerank_line.tsv'
  $stderr.puts "Launching hadoop streaming on self"
  %x{ hdp-stream '#{input_files}' '#{output_dir}' '#{mapred_script} --map' '#{mapred_script} --reduce' 2 }
  %x{ hdp-cp     '#{dummy_file}'  '#{output_dir}' }

else raise %Q{ 
  Need to specify an argument: --run_me, --map or --reduce
  You probably want to say
    ./pagerank/gen_initial_pagerank_graph.rb --runme out/20081220-sorted-uff  mid/20081220-pagerank_init.tsv
}
end
