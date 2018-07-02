class User < BaseModel
  table :users do
    column name : String
    column email : String
    column encrypted_password : String
  end
end
