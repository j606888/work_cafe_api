module HelperModules::QueryUser
  def query_user_by_id!(id)
    user = User.find_by(id: id)
    if user.nil?
      raise Service::PerformFailed, "User with id `#{id}` not found"
    end

    user
  end
end
