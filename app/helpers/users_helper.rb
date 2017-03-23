module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, size=50)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    gravatar_url << "?size=#{size}"
    image_tag(gravatar_url, alt: user.full_name, class: "gravatar")
  end
end