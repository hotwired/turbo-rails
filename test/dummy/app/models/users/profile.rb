module Users
  class Profile
    attr_reader :record_id, :name
  
    def self.model_name
      ActiveModel::Name.new(self)
    end
  
    def initialize(record_id:, name:)
      @record_id, @name = record_id, name
    end
  
    def to_key
      [ record_id ]
    end
  
    def to_partial_path
      "users/profiles/profile"
    end
  
    def model_name
      self.class.model_name
    end
  end
end
