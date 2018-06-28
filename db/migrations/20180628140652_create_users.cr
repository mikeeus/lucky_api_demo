class CreateUsers::V20180628140652 < LuckyMigrator::Migration::V1
  def migrate
    create :users do
      add name : String
      add email : String
      add encrypted_password : String
    end
  end

  def rollback
    drop :users
  end
end
