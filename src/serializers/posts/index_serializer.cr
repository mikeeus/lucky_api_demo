class Posts::IndexSerializer < Lucky::Serializer
  def initialize(@posts : PostQuery, @total : Int64)
  end

  def render
    {
      posts: @posts.map { |post| ShowSerializer.new(post) },
      total: @total,
    }
  end
end
