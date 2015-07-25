module Cropio
  module Connection
    module Configurable

      BASE_URL = 'https://cropio.com/api/v3'

      protected

      def headers
        authenticated? ? authenticated_headers : authentication_headers
      end

      def authentication_headers
        { content_type: :json, accept: :json }
      end

      def authenticated_headers
        authentication_headers.merge({
          'X-User-Api-Token' => Cropio.credentials.api_token
        })
      end
    end
  end
end
