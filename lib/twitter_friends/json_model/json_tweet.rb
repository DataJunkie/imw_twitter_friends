module TwitterFriends
  module JsonModel
    #
    # The JSON tweets records come off the wire a bit more heavyweight than we'd like.
    #
    # A sample JSON file, reformatted for clarity:
    #
    #
    # {
    #   "id"                           : 1012519767,
    #   "created_at"                   : "Wed Nov 19 07:16:58 +0000 2008",
    #   // twitter_user_id
    #   "favorited"                    : false,
    #   "truncated"                    : false,
    #   "in_reply_to_user_id"          : null,
    #   "in_reply_to_status_id"        : null,
    #   "text"                         : "[Our lander (RIP) had the best name. The next rover to Mars, @MarsScienceLab, needs a name. A contest for kids: http:\/\/is.gd\/85rQ  ]"
    #   "source"                       : "web",
    # }
    #
    class JsonTweet < GenericJsonParser
      attr_accessor :raw
      def initialize raw, twitter_user_id = nil
        self.raw = raw; return unless healthy?
        if twitter_user_id
          raw['twitter_user_id'] = twitter_user_id
        elsif raw['user'] && raw['user']['id']
          raw['twitter_user_id'] = raw['user']['id']
        end
        self.fix_raw!
      end
      def healthy?() raw && raw.is_a?(Hash) end

      #
      #
      # Make the data easier for batch flat-record processing
      #
      def fix_raw!
        raw['id']         = ModelCommon.zeropad_id(  raw['id'])
        raw['created_at'] = ModelCommon.flatten_date(raw['created_at'])
        raw['favorited']  = ModelCommon.unbooleanize(raw['favorited'])
        raw['truncated']  = ModelCommon.unbooleanize(raw['truncated'])
        raw['twitter_user_id']       = ModelCommon.zeropad_id(raw['twitter_user_id'] )
        raw['in_reply_to_user_id']   = ModelCommon.zeropad_id(raw['in_reply_to_user_id'])   unless raw['in_reply_to_user_id'].blank?
        raw['in_reply_to_status_id'] = ModelCommon.zeropad_id(raw['in_reply_to_status_id']) unless raw['in_reply_to_status_id'].blank?
        Wukong.encode_components raw, 'text'
      end

      def generate_tweet
        return unless healthy?
        Tweet.from_hash(raw)
      end
      #
      # produce the included last tweet
      #
      def generate_user_partial
        raw_user = raw['user'] or return
        JsonTwitterUser.new(raw_user, raw['created_at']).generate_user_partial
      end
    end
  end
end
