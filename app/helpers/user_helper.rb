module UserHelper
  def role(user)
    return 'root' if user.role == 'root'
    return 'admin' if user.role == 'admin'
    'free'
  end
end
