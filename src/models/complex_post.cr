class ComplexPost < BaseModel
  table :complex_posts do
    column title : String
    column content : String
    column author : String
  end

  def self.refresh
    LuckyRecord::Repo.db.exec "REFRESH MATERIALIZED VIEW complex_posts"
  end
end
