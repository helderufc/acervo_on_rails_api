module AuthHelper
  def auth_token_for(user)
    post "/auth/login", params: {
      user: { email: user.email, password: user.password }
    }, as: :json
    response.headers["Authorization"]
  end

  def auth_headers_for(user)
    { "Authorization" => auth_token_for(user) }
  end
end
