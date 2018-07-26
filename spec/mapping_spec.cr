require "./spec_helper"

describe App do
  describe "CustomPost" do
    it "maps query to class" do
      user = UserBox.new.name("Mikias").create
      post = PostBox.new
                    .user_id(user.id)
                    .title("DB mapping")
                    .content("Post content")
                    .create
  
      sql = <<-SQL
        SELECT
          posts.id,
          posts.title,
          ('PREFIX: ' || posts.content) as custom_key,
          json_build_object(
            'name', users.name,
            'email', users.email
          ) as author
        FROM posts
        JOIN users
        ON users.id = posts.user_id;
      SQL
  
      posts = LuckyRecord::Repo.run do |db|
        db.query_all sql, as: CustomPost
      end

      posts.size.should eq 1
      posts.first.title.should eq post.title
      posts.first.content.should eq "PREFIX: " + post.content
      posts.first.author["name"].should eq user.name
    end
  end
end

class CustomPost
  DB.mapping({
    id: Int32,
    title: String,
    content: {
        type: String,
        nilable: false,
        key: "custom_key"
    },
    author: JSON::Any
  })
end
