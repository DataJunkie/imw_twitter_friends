module TwitterFriends::StructModel

  
  #
  # I don't know what graph arcs are interesting
  # for RDF we're dumping
  #  user_a ==tweeted_hashtag=> hashtag
  # and
  #  tweet  ==has_hashtag=> hashtag
  #  
  Hashtag.class_eval do
    include TwitterFriends::TwitterRdf
    #
    # Ugh. We *really* wish we could reify in nt
    #
    def to_rdf3_tuples
      [
        [rdf_component(twitter_user_id, :user), rdf_pred(:tweeted_hashtag), rdf_component(text, :str), rdf_component(status_id, :tweet)],
        [rdf_component(status_id, :tweet),      rdf_pred(:has_hashtag),     rdf_component(text, :str), rdf_component(twitter_user_id, :user)],
      ]
    end
  end

  #
  # I don't know what graph arcs are interesting
  # for RDF we're dumping
  #  user_a ==tweeted_tweet_url=> tweet_url
  # and
  #  tweet  ==has_tweet_url=> tweet_url
  #  
  TweetUrl.class_eval do
    include TwitterFriends::TwitterRdf
    def to_rdf3_tuples
      [
        [rdf_component(twitter_user_id, :user), rdf_pred(:tweeted_url),     rdf_component(text, :str), rdf_component(status_id, :tweet)],
        [rdf_component(status_id, :tweet),      rdf_pred(:has_tweet_url),   rdf_component(text, :str), rdf_component(twitter_user_id, :user)],
      ]
    end
  end

  #
  # I don't know what graph arcs are interesting
  # for RDF we're dumping
  #  user ==retweets=> user
  # and
  #  user ==rtwhored_in=> status
  #  
  #
  ARetweetsB.class_eval do
    include TwitterFriends::TwitterRdf
    def to_rdf3_tuples
      if is_retweet?
        [
          [rdf_component(user_a_id, :user), rdf_pred(:retweets), rdf_component(user_b_name, :user), rdf_component(status_id, :tweet)],
        ]
      else
        [
          [rdf_component(user_a_id, :user), rdf_pred(:rtwhored_in), rdf_component(status_id, :tweet)],
        ]
      end
    end
  end

end
