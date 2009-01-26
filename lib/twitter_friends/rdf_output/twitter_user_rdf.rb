module TwitterFriends::StructModel
  module TwitterUserCommon
    def rdf_resource
      @rdf_resource ||= rdf_component(id, :user)
    end
  end
  [TwitterUser, TwitterUserProfile, TwitterUserStyle, TwitterUserPartial].each do |klass|
    klass.class_eval do
      include TwitterFriends::TwitterRdf
    end
  end
end
