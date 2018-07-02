class Posts::Show < ApiAction
  route do
    post = PostQuery.new.preload_user.find(id)
    json Posts::ShowSerializer.new(post)
  end
end
