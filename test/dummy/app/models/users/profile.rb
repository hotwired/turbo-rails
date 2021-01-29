module Users
  class Profile
    include ActiveModel::Model

    attr_accessor :id, :name

    def to_key
      [ id ]
    end

    def to_partial_path
      "users/profiles/profile"
    end
  end
end
