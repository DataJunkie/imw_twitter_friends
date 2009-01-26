module TwitterFriends
  module JsonModel

    # ===========================================================================
    #
    # Public timeline is an array of tweets => users
    #
    #
    class PublicTimelineParser < GenericJsonParser
      attr_accessor :scraped_at
      def initialize raw, context, scraped_at, *ignore
        super raw
        self.scraped_at = scraped_at
      end

      # Public timeline is an array of users with one tweet each
      def healthy?() raw && raw.is_a?(Array) end
      def each &block
        raw.each do |hsh|
          parsed = JsonTweet.new(hsh, nil)
          next unless parsed && parsed.healthy?
          [
            parsed.generate_user_partial,
            parsed.generate_tweet
          ].each do |obj|
            yield obj
          end
        end
      end
    end
  end
end
