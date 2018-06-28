require "./server"

Lucky::Session::Store.configure do
  settings.key = "blog_api"
  settings.secret = Lucky::Server.settings.secret_key_base
end
