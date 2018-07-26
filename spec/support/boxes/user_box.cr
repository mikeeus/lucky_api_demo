class UserBox < LuckyRecord::Box
  def initialize
    name "Mikias"
    email "mikias@mikias.net"
    encrypted_password "gibberish"
  end
end
