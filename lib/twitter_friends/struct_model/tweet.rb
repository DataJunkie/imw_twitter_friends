module TwitterFriends::StructModel

  #
  # Tweet
  #
  # Text and metadata for a twitter status update
  #
  class Tweet < Struct.new(
      :id,  :created_at, :twitter_user_id,
      :favorited, :truncated,
      :in_reply_to_user_id, :in_reply_to_status_id,
      :text,
      :source )
    include ModelCommon

    MEMBERS_TYPES = [
      [ :created_at            , :date     ],
      [ :twitter_user_id       , :user     ],
      [ :favorited             , :boolskip ],
      [ :truncated             , :boolskip ],
      [ :in_reply_to_user_id   , :user     ],
      [ :in_reply_to_status_id , :tweet    ],
      [ :text                  , :str      ],
      [ :source                , :str      ],
    ]
    #
    # Type info for output formatting
    #
    def members_with_types
      @members_with_types ||= MEMBERS_TYPES
    end

    #
    #
    # FIXME !!!
    # Memoized; if you change text you have to
    # flush
    #
    def decoded_text
      @decoded_text ||= text.wukong_decode
    end

    # Key on id
    def num_key_fields()  1  end

  end
end
