module QueryHelpers::QueryUser
  def find_user_by_id(id)
    user = User.find_by(id: id)
    return user if user.present?

    raise ActiveRecord::RecordNotFound, "User with id `#{id}` not found"
  end
end
