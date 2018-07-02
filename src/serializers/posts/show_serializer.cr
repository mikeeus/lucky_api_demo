class Posts::ShowSerializer < Lucky::Serializer
  def initialize(@post : Post)
  end

  def render
    {
      id: @post.id,
      title: @post.title,
      content: @post.content,
      author: @post.user!.name,
      tags: @post.tags,
      published_at: @post.published_at
    }
  end
end