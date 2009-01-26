module TwitterFriends
  module JsonModel
    # ===========================================================================
    #
    # Friends or Followers is a flat list of users => tweets
    #
    #
    class FriendsFollowersParser < GenericJsonParser
      attr_accessor :scraped_at, :context, :owning_user_id
      def initialize raw, context, scraped_at, owning_user_id, *ignore
        super raw
        self.context         = context.to_sym
        self.scraped_at      = scraped_at
        self.owning_user_id  = owning_user_id
      end

      # Extracted JSON should be an array
      def healthy?() raw && raw.is_a?(Array) end

      def generate_relationship user, tweet
        case context
        when :followers then AFollowsB.new(  user.id,        owning_user_id)
        when :friends   then AFollowsB.new(  owning_user_id, user.id)
        when :favorites then AFavoritesB.new(owning_user_id, user.id, (tweet ? tweet.id : nil))
        else raise "Can't make a relationship out of #{context}. Perhaps better communication is the key."
        end
      end

      #
      # Enumerate over users (each having one tweet)
      #
      def each &block
        raw.each do |hsh|
          case context
          when :favorites then parsed = JsonTweet.new(      hsh, nil)
          else                 parsed = JsonTwitterUser.new(hsh, scraped_at)
          end
          next unless parsed && parsed.healthy?
          user_b = parsed.generate_user_partial
          tweet  = parsed.generate_tweet
          [ user_b,
            tweet,
            generate_relationship(user_b, tweet)
          ].compact.each do |obj|
            yield obj
          end
        end
      end
    end

  end
end
