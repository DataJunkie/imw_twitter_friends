#!/usr/bin/env ruby
require 'rubygems'
require 'yaml'

$: << File.dirname(__FILE__)+'/lib'
require 'wukong' ; include Wukong
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/scrape'       ; include TwitterFriends::Scrape
require 'twitter_friends/json_model'   ; include TwitterFriends::JsonModel

# Make sure this file doesn't go into source control.
CONFIG = YAML.load(File.open(File.dirname(__FILE__)+'/config/private.yaml'))
# How often to holla
PROGRESS_INTERVAL = 1000
# How long to sleep between fetch sessions
SLEEP_INTERVAL    = 0.5
# How often to checkpoint progress to disk
TwitterFriends::Scrape::ScrapeDumper::CHECKPOINT_INTERVAL = 15*60

$progress_count = 0
def track_progress *record
  $progress_count += 1
  return unless ($progress_count % PROGRESS_INTERVAL == 1)
  $stderr.puts(['progress:', Time.now, $progress_count, record].flatten.join("\t"))
end

class TwitterScrapeRequest < ScrapeRequest
  include TwitterApi

  def initialize *args
    super *args
    self.url ||= gen_url
  end
end


class TwitterUserRequests < ScrapeRequestGroup
  attr_accessor :scraper
  def initialize *args
    super *args
    self.scraper = HTTPScraper.new('twitter.com')
  end
  def self.contexts
    # [:followers, :friends, :favorites, :user_timeline]
    [ :friends_ids, :followers_ids]
  end

  def pages context
    TwitterApi.pages context, thing
  end

  def each_context &block
    self.class.contexts.each do |context|
      yield context
    end
  end
  def each_page context, &block
    (1..pages(context)).each do |page|
      yield page
    end
  end

  #
  #
  #
  def gen_priority context
    case context
    when :user, :followers_ids, :friends_ids
      TwitterApi.pages(:followers, thing)
    when :friends
      [ (100 * thing.friends_per_day).to_i, 1 ].max
    when :favorites, :followers, :user_timeline
      TwitterApi.pages(context, thing)
    else raise "need to define priority for context #{context}"
    end
  end


  def get_user
    user_request = TwitterScrapeRequest.new( :user, gen_priority(:user), thing.id, 1, thing.screen_name )
    scraper.get! user_request
    parsed = UserParser.new_from_json(
       user_request.contents, user_request.context,
        user_request.scraped_at, user_request.identifier,
        user_request.page, user_request.moreinfo)
    if parsed && parsed.user
      new_user = parsed.generate_twitter_user
      new_user.id = thing.id if new_user
      self.thing = new_user  if new_user
    end
    user_request
  end

  def each_request &block
    user_request = get_user
    yield get_user
    each_context do |context|
      each_page(context) do |page|
        priority = gen_priority(context)
        scrape_request =  TwitterScrapeRequest.new( context, priority, thing.id, page, thing.screen_name )
        scraper.get! scrape_request
        yield scrape_request
      end
    end
  end
end


#
# Set up
#
RIPD_ROOT = '/workspace/flip/data/ripd'
REQUEST_FILENAME = 'rawd/scrape_requests-20090203-aa-restart.tsv'
scrape_dumper = ScrapeDumper.new(RIPD_ROOT+'/_com/_tw/com.twitter/bundled', "bundle")
#
# Walk thru requests list
#
File.open(REQUEST_FILENAME).each do |line|
  id, followers_count, rsrc  = line.chomp.split("\t")[0..(TwitterUser.members.length-1)]
  #
  # Generate requests
  #
  twitter_user                 = TwitterUser.new()
  twitter_user.id              = "%010d"%id.to_i
  twitter_user.followers_count = followers_count.to_i
  scrape_requests              = TwitterUserRequests.new(twitter_user)
  #
  # Save output
  #
  scrape_requests.each_request do |scrape_request|
    track_progress(scrape_request.context, scrape_requests.thing.to_a)
    scrape_dumper.checkpoint!
    scrape_dumper << scrape_request.dump_form
    if (scrape_request.response_code.to_i != 200) then warn "Bad fetch, sleeping #{SLEEP_INTERVAL}" ; sleep SLEEP_INTERVAL ; end
  end
end
scrape_dumper.close!
