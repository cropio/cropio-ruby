module Cropio
  module Connection
    # Contains logic for requests configuration
    # like appending headers to requests.
    module Configurable
      # Cropio's server and API's entry point url
      BASE_URL = 'https://cropio.com/api/v3'

      protected

      # Returns headers set for request.
      def headers
        authenticated? ? authenticated_headers : authentication_headers
      end

      # Returns headers for authentication query.
      def authentication_headers
        { content_type: :json, accept: :json }
      end

      # Returns headers for authenticated queries.
      def authenticated_headers
        authentication_headers.merge(
          'X-User-Api-Token' => Cropio.credentials.api_token)
      end
    end
  end
end
