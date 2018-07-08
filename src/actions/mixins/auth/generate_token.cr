require "jwt"

module GenerateToken
  def generate_token(user)
    exp = Time.now.epoch + 14 * 24 * 60 * 60 # 14 days
    data = ({ id: user.id, name: user.name, email: user.email }).to_s
    payload = { "sub" => user.id, "user" => Base64.encode(data), "exp" => exp }

    JWT.encode(payload, Lucky::Server.settings.secret_key_base, "HS256")
  end
end