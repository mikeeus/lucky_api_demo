class PostForm < Post::BaseForm
  fillable title, content, tags, comment_id
  needs author : User, on: :create

  def prepare
    author.try do |user|
      user_id.value = user.id
    end

    published_at.value = Time.now
    set_slug
  end

  private def set_slug
    generated_slug = (title.value || "").gsub(" ", "-").gsub(/[^\w-]/, "")

    if slug_exists?(generated_slug)
      generated_slug += "-" + Time.now.epoch.to_s
    end

    slug.value = generated_slug
  end

  private def slug_exists?(slug : String)
    PostQuery.new.slug(slug).count > 0
  end
end
