#!/usr/bin/env ruby
require 'fileutils'; include FileUtils
$: << File.dirname(__FILE__)+'/../lib'

require 'wukong'
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/scrape'       ; include TwitterFriends::Scrape

#
# Stage I :
#

#
# !!! NOTE !!!
#
# A bundled file is NOT a conventional tar-separated file: consider the last
# field (containing the raw JSON) to be arbitrary text.
#
class BundleMapper < Wukong::Streamer
  #
  # emit the description and then the contents of each file
  #
  def extract_tar_file tar_filename
    scrape_store = TarScrapeStore.new(tar_filename)
    scrape_store.extract!
    scrape_store.contents do |scraped_file, contents|
      puts [
        scraped_file.values_of(:context, :scraped_at, :identifier, :page, :moreinfo ),
        contents
      ].flatten.join("\t")
    end
  end

  def process resource, *vals
    tar_filename = resource.split(/\s+/).last
    extract_tar_file tar_filename
  end
end

class BundleStage1Script < Wukong::Script
end

#
# Execute
#

BundleStage1Script.new(BundleMapper, nil).run

