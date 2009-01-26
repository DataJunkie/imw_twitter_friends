#!/usr/bin/env ruby
require 'rubygems'
require 'json'
require 'imw' ; include IMW
as_dset __FILE__
require 'fileutils'; include FileUtils
require 'twitter_scrape_model'

class << Addressable::URI
  alias_method :encode_segment,   :encode_component
  alias_method :unencode_segment, :unencode_component
end

RIPD_ROOT = path_to(:ripd_root)

TwitterScrapeFile.class_eval do
  #
  # Using no timestamp and old cascading scheme
  #
  def old_ripd_file
    base_path = "_com/_tw/com.twitter/#{resource_path}"
    prefix    = (screen_name+'.')[0..1]
    slug_path = "_" + prefix.downcase
    filename  = "#{screen_name}.json%3Fpage%3D#{page}"
    File.join(RIPD_ROOT, base_path, slug_path, filename) # :ripd_root
  end
  #
  # Recognize old file paths
  #
  RIPD_FILE_RE = %r{_com/_tw/com.twitter/(\w+/\w+)/_\w[\w\.]/(\w+)\.json%3Fpage%3D(\d+)}
  #
  # create a scrape_file for an existing file
  #
  def self.new_from_old_ripd_file filename
    m = RIPD_FILE_RE.match(filename)
    unless m then warn "Can't grok filename #{filename}"; return nil; end
    timestamp = File.mtime(filename) if File.exists?(filename)
    resource, screen_name, page = m.captures
    context = TwitterScrapeFile::RESOURCE_PATH_FROM_CONTEXT.invert[resource]
    scrape_file = self.new screen_name, context, page, timestamp
    scrape_file
  end
end

#
# Walk all files in the scraped directory and copy them to the new (correct) file scheme
#
def mass_migrate_files
  cd path_to(:ripd_root) do
    Dir["_com/_tw/com.twitter/*/*"].sort.each do |resource|
      Dir["#{resource}/_*"].sort.each do |dir|
        Dir["#{dir}/*"].each do |ripd_file|
          track_count dir, 1_000
          scrape_file = TwitterScrapeFile.new_from_old_ripd_file(ripd_file)
          next unless scrape_file
          mkdir_p File.dirname(scrape_file.file_path)
          # puts "mv %-80s %s" % ["'#{ripd_file}'", "'#{scrape_file.file_path}'"]
          mv ripd_file,  scrape_file.file_path   # , :verbose => true
        end
      end
    end
  end
end
mass_migrate_files

