class UserBox < LuckyRecord::Box
  def initialize
    name "Mikias"
    email "hello@mikias.net"
    encrypted_password Authentic.generate_encrypted_password("password")
  end
end