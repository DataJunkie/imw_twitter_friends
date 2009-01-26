module TwitterFriends
  module JsonModel

    class UserParser < GenericJsonParser
      attr_accessor :scraped_at
      def initialize raw, context, scraped_at, *ignore
        super raw
        self.scraped_at = scraped_at
      end
      def healthy?() raw && raw.is_a?(Hash) end

      def user
        @user ||= JsonTwitterUser.new(raw, scraped_at)
      end

      def generate_twitter_user
        user.generate_user_classes(TwitterUser).first
      end

      def each &block
        user.generate_user_profile_and_style.each do |obj|
          yield obj
        end
        tweet = user.generate_tweet
        yield tweet if tweet
      end
    end

  end
end
