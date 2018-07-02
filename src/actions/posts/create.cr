class Posts::Create < ApiAction
  route do
    post = PostForm.create!(params, author: UserQuery.new.first)
    json Posts::ShowSerializer.new(post), Status::Created
  end
end
