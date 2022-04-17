module UserHelper
  def role(user)
    return 'root' if user.has_role?(:root)
    return 'admin' if user.has_role?(:admin)
    'free'
  end
end
