class Posts::Create < AuthenticatedAction
  route do
    post = PostForm.create!(params, author: current_user)
    json Posts::ShowSerializer.new(post), Status::Created
  end
end
