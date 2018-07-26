require "./spec_helper"

describe App do
  describe "ComplexPost matview" do
    it "should refresh and query" do
      user = UserBox.new.create
      first_post = PostBox.new.title("First").user_id(user.id).create
      second_post = PostBox.new.title("Second").user_id(user.id).create

      ComplexPost.refresh

      complex = ComplexPostQuery.new.title(first_post.title).first
      complex.title.should eq first_post.title
    end
  end
end
