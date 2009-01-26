module TwitterFriends
  module JsonModel

    #
    # The JSON user records come off the wire a bit more heavyweight than we'd like.
    #
    # We vertically partition the single user record into three, as described above:
    # one with the fundamental info, one with user's personal info (name, location,
    # etc) and one with the styling they've applied to their homepage.
    #
    # A sample JSON file, reformatted for clarity:
    #
    #    {
    #      "id"                           : 14693823,
    #      // scraped_at added in processing
    #      "screen_name"                  : "MarsPhoenix"
    #      "protected"                    : false,
    #      "followers_count"              : 39452,
    #      "friends_count"                : 3,
    #      "statuses_count"               : 609,
    #      "favourites_count"             : 5,
    #      "created_at"                   : "Thu May 08 00:17:54 +0000 2008",
    #
    #      // "id"                        : 14693823,
    #      // scraped_at added in processing
    #      "name"                         : "MarsPhoenix",
    #      "url"                          : "http:\/\/tinyurl.com\/5wwaru",
    #      "location"                     : "Mars, Solar System",
    #      "description"                  : "I dig Mars! ",
    #      "time_zone"                    : "Pacific Time (US & Canada)",
    #      "utc_offset"                   : -28800,
    #
    #      // "id"                        : 14693823,
    #      // scraped_at added in processing
    #      "profile_background_color"     : "9ae4e8",
    #      "profile_text_color"           : "000000",
    #      "profile_link_color"           : "0000ff",
    #      "profile_sidebar_border_color" : "87bc44",
    #      "profile_sidebar_fill_color"   : "e0ff92",
    #      "profile_background_tile"      : true,
    #      "profile_image_url"            : "http:\/\/s3.amazonaws.com\/twitter_production\/profile_images\/55133915\/PIA09942_normal.jpg",
    #      "profile_background_image_url" : "http:\/\/s3.amazonaws.com\/twitter_production\/profile_background_images\/3069906\/PSP_008591_2485_RGB_Lander_Detail_516-387.jpg",
    #
    #      // Sometimes:
    #      "status"                       :  { ... a tweet record: see tweet.tsv ... }
    #
    #    }
    #
    class JsonTwitterUser
      attr_accessor :raw
      def initialize raw, scraped_at
        self.raw = raw; return unless healthy?
        self.raw['scraped_at'] = scraped_at
        self.fix_raw!
      end
      def healthy?() raw && raw.is_a?(Hash) end

      # user id from the raw hash
      def twitter_user_id
        raw['id']
      end

      #
      # Make the data easier for batch flat-record processing
      #
      def fix_raw!
        raw['created_at'] = ModelCommon.flatten_date(raw['created_at'])
        raw['id']         = ModelCommon.zeropad_id(raw['id'])
        raw['protected']  = ModelCommon.unbooleanize(raw['protected'])
        Wukong.encode_components raw, 'name', 'location', 'description', 'url'
        # There are several users with bogus screen names
        # These we need to **URL encode** -- not XML-encode.
        if raw['screen_name'] !~ /\A\w+\z/
          raw['screen_name'] = Wukong.encode_str(raw['screen_name'], :url)
        end
      end

      #
      #
      # Expand a user .json record into model instances
      #
      # Ex.
      #   # Parse a complete twitter users/show/foo.json record
      #   twitter_user, twitter_user_profile, twitter_user_style =
      #     JsonUser.generate_user_classes TwitterUser, TwitterUserProfile, TwitterUserStyle
      #
      #   # just get the id and screen_name
      #   JsonUser.generate_user_classes TwitterUserId
      #
      def generate_user_classes *klasses
        return [] unless healthy?
        klasses.map do |klass|
          klass.from_hash(raw)
        end
      end
      #
      # Create TwitterUser, TwitterUserProfile, and TwitterUserStyle
      # instances from this hash
      #
      def generate_user_profile_and_style
        generate_user_classes TwitterUser, TwitterUserProfile, TwitterUserStyle
      end
      #
      # Create TwitterUserPartial from this hash -- use this when you only have a
      # partial listing, for instance in the public timeline or another user's
      # followers list
      #
      def generate_user_partial
        generate_user_classes(TwitterUserPartial).first
      end
      #
      # produce the included last tweet
      #
      def generate_tweet
        raw_tweet = raw['status']
        JsonTweet.new(raw_tweet, twitter_user_id).generate_tweet if raw_tweet
      end
    end

  end
end
