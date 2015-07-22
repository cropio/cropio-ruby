module Cropio::Connection::Authenticable
  def authenticate!
    auth_request
  end

  protected

  def auth_request
    result = RestClient.post("#{BASE_URL}/sign_in", auth_request_params.to_json,
                        authentication_headers)
    process_result(result)
  end

  def process_result(result)
    result = JSON.parse(result)

    if result['success']
      Cropio.credentials.api_token = result['user_api_token']
      true
    else
      fail 'Access to Cropio denied.'
    end
  end

  def auth_request_params
    {
      user_login: {
        email: Cropio.credentials.email,
        password: Cropio.credentials.password
      }
    }
  end
end
