class Posts::Index < ApiAction
  route do
    posts = PostQuery.new.preload_user.latest
    total = PostQuery.new.published.count
    json Posts::IndexSerializer.new(posts, total)
  end
end
