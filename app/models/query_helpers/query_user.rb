module QueryHelpers::QueryUser
  def find_user_by_id(id, optional: false)
    user = User.find_by(id: id)
    return user if user.present? || optional

    raise ActiveRecord::RecordNotFound, "User with id `#{id}` not found"
  end
end
