module TwitterFriends::StructModel

  #
  # Mixin: common methods for each of the user representations / partitions
  #
  module TwitterUserCommon
    #
    # Datatype info, for exporting strings
    #
    MEMBERS_TYPES = {
      :created_at,          :date,
      :scraped_at,          :date,
      :screen_name,         :str,
      :protected,           :bool,
      :followers_count,     :int,
      :friends_count,       :int,
      :statuses_count,      :int,
      :favourites_count,    :int,
      :name,                :str,
      :url,                 :str,
      :location,            :str,
      :description,         :str,
      :time_zone,           :str,
      :utc_offset,          :int,
      # :profile_background_color,       :str,
      # :profile_text_color,             :str,
      # :profile_link_color,             :str,
      # :profile_sidebar_border_color,   :str,
      # :profile_sidebar_fill_color,     :str,
      # :profile_background_tile,        :bool,
      # :profile_background_image_url,   :str,
      # :profile_image_url,              :str,
    }
    def members_with_types
      @members_with_types ||= MEMBERS_TYPES.slice(*members.map(&:to_sym))
    end

    #
    # Key on id
    #
    # For mutability (preserving different scraped_at observations)
    # needs to be 2 -- id and scraped_at
    #
    def num_key_fields()  1  end
    # #
    # def keyspace_spread_resource_name
    #   "%s-%s" % [ self.resource_name, self.id.to_s[-2..-1] ]
    # end

    def decoded_name
      @decoded_name        ||= (name        ? name.wukong_decode : '')
    end
    def decoded_location
      @decoded_location    ||= (location    ? location.wukong_decode : '')
    end
    def decoded_description
      @decoded_description ||= (description ? description.wukong_decode : '')
    end
  end

  #
  # Fundamental information on a user.
  #
  class TwitterUser        < TypedStruct.new([
      [:id,                     Integer],
      [:scraped_at,             Bignum],
      [:screen_name,            String],
      [:protected,              Integer],
      [:followers_count,        Integer],
      [:friends_count,          Integer],
      [:statuses_count,         Integer],
      [:favourites_count,       Integer],
      [:created_at,             Bignum], ])
    include ModelCommon
    include TwitterUserCommon
    alias_method :tweets_count,    :statuses_count
    alias_method :favorites_count, :favourites_count

    #
    # Rate info
    #
    def friends_per_day()      friends_count.to_i   / days_since_created  end
    def followers_per_day()    followers_count.to_i / days_since_created  end
    def favorites_per_day()    favorites_count.to_i / days_since_created  end
    def tweets_per_day()       tweets_count.to_i    / days_since_created  end

  end

  #
  # Outside of a users/show page, when a user is mentioned
  # only this subset of fields appear.
  #
  class TwitterUserPartial < Struct.new(
      :id, :scraped_at,
      :screen_name, :protected, :followers_count, # appear in TwitterUser
      :name, :url, :location, :description,       # appear in TwitterUserProfile
      :profile_image_url )                        # appear in TwitterUserStyle
    include ModelCommon
    include TwitterUserCommon
  end

  #
  # User-set information about a user
  #
  class TwitterUserProfile < Struct.new(
      :id, :scraped_at,
      :name, :url, :location, :description,
      :time_zone, :utc_offset )
    include ModelCommon
    include TwitterUserCommon
  end

  #
  # How the user has styled their page
  #
  class TwitterUserStyle   < Struct.new(
      :id, :scraped_at,
      :profile_background_color,
      :profile_text_color,           :profile_link_color,
      :profile_sidebar_border_color, :profile_sidebar_fill_color,
      :profile_background_tile,      :profile_background_image_url,
      :profile_image_url )
    include ModelCommon
    include TwitterUserCommon
  end

  #
  # For passing around just screen_name => id mapping
  #
  class TwitterUserId      < Struct.new(
      :id, :screen_name, :full )
    include ModelCommon
    include TwitterUserCommon
    def num_key_fields()  1  end
  end
end



    # MUTABLE_ATTRS = [
    #   :followers_count, :friends_count, :statuses_count, :favourites_count,
    #   :name, :url, :location, :description, :time_zone, :utc_offset,
    #   :profile_background_color, :profile_text_color, :profile_link_color, :profile_sidebar_border_color, :profile_sidebar_fill_color, :profile_background_tile, :profile_background_image_url, :profile_image_url
    # ].to_set
    # def mutable?(attr)
    #   MUTABLE_ATTRS.include?(attr)
    # end
