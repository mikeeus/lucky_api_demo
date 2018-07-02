class PostBox < LuckyRecord::Box
  def initialize
    title "Post"
    content "Awesome post!"
    slug "post"
    tags "awesome, dope"
    published_at Time.new
    comment_id 1
  end
end