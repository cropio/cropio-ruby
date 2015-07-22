module Cropio::Connection::Configurable

  BASE_URL = 'https://cropio.com/api/v3'

  protected

  def headers
    authenticated? ? authenticated_headers : authentication_headers
  end

  def authenticated?
    Cropio.credentials.api_token.present?
  end

  def authentication_headers
    { 'content-type' => 'application/json' }
  end

  def authenticated_headers
    authentication_headers.merge({
      'X-User-Api-Token' => Cropio.credentials.api_token
    })
  end
end
