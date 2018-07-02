class CreatePosts::V20180628140710 < LuckyMigrator::Migration::V1
  def migrate
    create :posts do
      add title : String
      add content : String
      add slug : String
      add tags : String
      add published_at : Time
      add comment_id : Int32
      add_belongs_to user : User, on_delete: :cascade
    end
  end

  def rollback
    drop :posts
  end
end
