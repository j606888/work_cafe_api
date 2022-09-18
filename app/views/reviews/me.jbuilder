if review.present?
  json.partial! 'item', review: review
  json.user_avatar_url review.user.avatar_url
  json.user_name review.user.name
else
  json.nil!
end
