#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../lib'

require 'wukong'                       ; include Wukong
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/scrape'       ; include TwitterFriends::Scrape


INPUT_FILE="rawd/scrape_requests/expanded_urls-20090115.tsv"

File.open(INPUT_FILE).each do |line|
  _, src_url, dest_url, scraped_at = line.chomp.split("\t")
  expanded_url = ExpandedUrl.new(src_url, dest_url, scraped_at)
  expanded_url.fetch_dest_url!( :sleep => 0 )
  puts expanded_url.output_form
end
