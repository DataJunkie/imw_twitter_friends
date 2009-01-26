module TwitterFriends::StructModel
  Tweet.class_eval do
    include ModelCommon
    include TwitterFriends::TwitterRdf
    def rdf_resource
      @rdf_resource ||= rdf_component(id, :tweet)
    end

  end
end
