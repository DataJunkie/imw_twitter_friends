module TwitterFriends::StructModel
  class Token < Struct.new(:context, :owner, :word, :freq)
    include ModelCommon

    def initialize *args
      super *args
      freq = 1 if freq.blank? && (! word.blank?)
    end

    def num_key_fields
      3
    end
  end
end
