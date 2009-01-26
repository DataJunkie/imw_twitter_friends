#!/usr/bin/env ruby
$: << File.dirname(__FILE__)+'/../lib'

require 'wukong'                       ; include Wukong
require 'twitter_friends/struct_model' ; include TwitterFriends::StructModel
require 'twitter_friends/scrape'       ; include TwitterFriends::Scrape

#
# See bundle.sh for running pattern
#

module GenReqsExpandedUrls
  class Mapper < Wukong::StructStreamer
    #
    #
    def process thing
      case thing
      when ExpandedUrl
        thing.dest_url   = ExpandedUrl.scrub_url(thing.dest_url)
        thing.scraped_at = TwitterFriends::StructModel::ModelCommon.flatten_date(thing.scraped_at)
        thing.fix_src_url!
        puts thing.output_form
      when TweetUrl
        tinyurlish = ExpandedUrl.new_if_tinyurlish(thing.tweet_url) or return
        puts tinyurlish.output_form
      end
    end

    # # dump just the host part (debugging method)
    # def host_part tweet_url
    #   puts tweet_url.tweet_url.gsub(%r{\A.*\w+://([a-zA-Z0-9\.]+).*?\z}, '\1')
    # end
  end

  class Reducer < Wukong::AccumulatingReducer
    attr_accessor :expanded_url
    def reset!
      self.expanded_url = ExpandedUrl.new
    end

    #
    # KLUDGE
    # This seems like a kinda crappy way to do a merge-non-blank
    #
    def accumulate key, src_url, dest_url=nil, scraped_at=nil
      expanded_url.src_url    = src_url    if expanded_url.src_url.blank?
      expanded_url.dest_url   = dest_url   if expanded_url.dest_url.blank?
      expanded_url.scraped_at = scraped_at if expanded_url.scraped_at.blank?
    end

    #
    def finalize
      puts expanded_url.output_form
    end

  end

  class Script < Wukong::Script
    # def reduce_command
    #   '/usr/bin/uniq -c'
    # end
  end
end

#
# Executes the script
#
GenReqsExpandedUrls::Script.new(GenReqsExpandedUrls::Mapper, GenReqsExpandedUrls::Reducer).run


# thing.dest_url.gsub!(/[<>\"\t\\]/, '')
# if ! scrubbed.blank?
#   puts [thing.src_url, scrubbed, thing.dest_url, thing.scraped_at].join("\t")
# end



# tinyurl.com
# is.gd
# snipurl.com
# snurl.com
# bit.ly
# tr.im
# urlenco.de
# url.ie
# tiny.cc
# ff.im
# twurl.nl
# bkite.com
# blip.fm
# ping.fm
# snipr.com
# budurl.com
# cli.gs
# zi.ma
# piurl.com
# adjix.com
# zz.gd
# poprl.com
# ad.vu
# ow.ly
# funp.com
# ur1.ca
# tiny12.tv
# rubyurl.com
# xrl.us
# s3nt.com
# plazes.com
# blip.tv
# urlbrief.com
# short.to
# idek.net
# moourl.com
# twurl.cc
# rurl.org
# ruwt.tv
# logpi.jp
# ub0.cc
# jijr.com
# fon.gs
# fleck.com
