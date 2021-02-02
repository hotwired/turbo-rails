module Users
  class Profile
    include ActiveModel::Model
    include Turbo::Broadcastable

    attr_accessor :id, :name

    def to_param
      "users:profile:#{id}"
    end

    def to_partial_path
      "users/profiles/profile"
    end
  end
end
