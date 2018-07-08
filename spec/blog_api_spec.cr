require "./spec_helper"

describe App do
  visitor = AppVisitor.new

  describe "/" do
    it "says hello" do
      visitor.visit("/")

      visitor.response_body.should eq ({ "hello" => "Hello World from Home::Index" })
    end
  end

  describe "/posts" do
    it "returns latest posts" do
      user = UserBox.create
      post1 = PostBox.new.user_id(user.id).title("Post 1").create
      post2 = PostBox.new.user_id(user.id).title("Post 2").create

      visitor.visit("/posts")

      visitor.response_body["total"].should eq 2
      visitor.response_body["posts"].size.should eq 2
      visitor.response_body["posts"][0]["title"].should eq "Post 1"
    end

    it "shows post" do
      user = UserBox.create
      post1 = PostBox.new.user_id(user.id).title("Dope post").create

      visitor.visit("/posts/#{post1.id}")
      visitor.response_body["title"].should eq "Dope post"
    end

    it "creates post" do
      user = UserBox.create

      visitor.post("/posts", ({
        "post:title" => "New Post",
        "post:content" => "Probably the best post you've ever read",
        "post:published_at" => Time.now.to_s,
        "post:tags" => "dope, informative",
        "post:comment_id" => "1"
      }))

      visitor.response_body["title"].should eq "New Post"
    end
  end

  describe "auth" do
    it "signs in valid user" do
      # create a user
      user = UserBox.new.create
      
      # visit sign in endpoint
      visitor.post("/auth/sign_in", ({
        "sign_in:email" => user.email,
        "sign_in:password" => "password"
      }))
      
      # check response has status: 200 and authorization header with "Bearer"
      visitor.response.status_code.should eq 200
      visitor.response.headers["Authorization"].should_not be_nil
    end
  end
end
