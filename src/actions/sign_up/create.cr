class SignUp::Create < ApiAction
  include GenerateToken

  route do
    SignUpForm.create(params) do |form, user|
      if user
        context.response.headers.add "Authorization", generate_token(user)
        head 200
      else
        head 401
      end
    end
  end
end
