module TwitterFriends::StructModel

  #
  #
  #
  module TextElementCommon
    # Key on text-status_id
    def num_key_fields()  2  end
    # #
    # # use text. but carefully
    # #
    # def keyspace_spread_resource_name
    #   # To make sure there's something, grab last 2 of status_id as fallback
    #   slug = self.status_id.to_s[-2..-1]
    #   # use first two of text, but only alphanums
    #   slug = ( text.gsub(/\W+/, '') + slug )[0..1].downcase
    #   [self.resource_name, slug].join("-")
    # end
  end

  #
  # Topical #hashtags extracted from tweet text
  #
  # the twitter_user_id is denormalized
  # but is often what we wnat: saves a join
  #
  class Hashtag < Struct.new( :hashtag,    :status_id, :twitter_user_id )
    include ModelCommon
    include TextElementCommon
    alias_method :text, :hashtag
  end

  class TweetUrl < Struct.new( :tweet_url, :status_id, :twitter_user_id )
    include ModelCommon
    include TextElementCommon
    alias_method :text, :tweet_url
  end
end
