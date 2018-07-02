require "./user"

class Post < BaseModel
  table :posts do
    column title : String
    column content : String
    column slug : String
    column tags : String
    column published_at : Time
    column comment_id : Int32
    belongs_to user : User
  end
end
