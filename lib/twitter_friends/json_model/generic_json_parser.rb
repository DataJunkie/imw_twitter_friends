module TwitterFriends
  module JsonModel
    class GenericJsonParser
      attr_accessor :raw
      def initialize raw
        self.raw = raw
      end
      def healthy?() raw && raw.is_a?(Hash) end

      #
      # Safely parse the json object and instantiate with the raw hash
      #
      def self.new_from_json json_str, *args
        return unless json_str
        begin
          raw = JSON.load(json_str) or return
        rescue Exception => e; return ; end
        self.new raw, *args
      end
    end

  end
end
