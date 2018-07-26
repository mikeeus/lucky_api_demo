class CreateComplexPostsMatview::V20180726082301 < LuckyMigrator::Migration::V1
  def migrate
    execute <<-SQL
      CREATE MATERIALIZED VIEW complex_posts AS
        SELECT
          posts.id,
          posts.title,
          posts.content,
          users.name as author,
          NOW() as created_at,
          NOW() as updated_at
        FROM posts
        JOIN users
        ON users.id = posts.user_id
    SQL

    execute "CREATE UNIQUE INDEX complex_posts_id_index ON complex_posts (id)"
  end

  def rollback
    execute "DROP MATERIALIZED VIEW complex_posts"
  end
end
