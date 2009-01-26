require 'twitter_friends/grok/tweet_regexes'
require 'twitter_friends/struct_model'
include TwitterFriends::Grok::TweetRegexes
include TwitterFriends::StructModel

Tweet.class_eval do

  #
  #
  #
  def tweet_len
    decoded_text.length
  end

  #
  # Any mention of another user, whether at the beginning of a line (and thus
  # *also* an ARepliesB), a retweet, or just somewhere in the body of the text
  #
  def replies
    if (! in_reply_to_user_id.blank?)
      ARepliesB.new(twitter_user_id, in_reply_to_user_id, self.id, in_reply_to_status_id)
    end
  end

  #
  # Any mention of another user, whether at the beginning of a line (and thus
  # *also* an ARepliesB), a retweet, or just somewhere in the body of the text
  #
  def atsigns
    matches = decoded_text.scan(RE_ATSIGNS)
    matches.map do |user_b_name|
      user_b_name = user_b_name.first.hadoop_encode
      AAtsignsB.new(twitter_user_id, user_b_name, self.id)
    end
  end

  #
  # Remember that a retweet could be an actual retweet, a retweet whore request,
  # or a retweet of a retweet whore request.
  #
  # Or, it could have just fooled us. 
  #
  # Anyway you can take it from here.
  # 
  def retweets
    please_flag   = RE_RTWHORE.match(decoded_text)
    retweet_match = RE_RETWEET.match(decoded_text)
    return unless please_flag || retweet_match
    user_b_name   = retweet_match.captures.first.hadoop_encode if retweet_match
    ARetweetsB.new(twitter_user_id, user_b_name, self.id, please_flag, self.text)
  end

  #
  # Hashtags indicate a topic: #hashtag
  #
  def hashtags
    matches = decoded_text.scan(RE_HASHTAGS)
    matches.map do |hashtag_text|
      hashtag_text = hashtag_text.first.hadoop_encode
      Hashtag.new(hashtag_text, self.id, twitter_user_id)
    end
  end

  #
  # URLs within a tweet.
  # can be multiple per tweet.
  #
  # Uses a regexp more selective than all canonically allowed - see
  # tweet_regexes
  #
  def tweet_urls
    matches = decoded_text.scan(RE_URL)
    matches.map do |tweet_url_text|
      tweet_url_text = tweet_url_text.first.hadoop_encode
      TweetUrl.new(tweet_url_text, self.id, twitter_user_id)
    end
  end
  
  def text_elements
    # replies # done in tweet??
    # atsigns
    # tweet_url
    # hashtags
    # tweet length
    # words
    [
      replies,
      atsigns,
      retweets,
      hashtags,
      tweet_urls,
    ].compact.flatten
  end

end
