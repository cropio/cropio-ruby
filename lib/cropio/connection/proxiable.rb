require'rest-client'

module Cropio
  module Connection
    module Proxiable
      def get(resource, query={})
        JSON.parse RestClient::Request.execute(method: :get, url: url_for(resource), headers: {params: query}.merge(headers))
      end

      def post(resource, data)
        JSON.parse RestClient.post(url_for(resource), data.to_json, headers)
      end

      def patch(resource, data)
        JSON.parse RestClient.patch(url_for(resource), data.to_json, headers)
      end

      def delete(resource)
        JSON.parse RestClient.delete(url_for(resource), headers)
      end

      protected

      def url_for(resource)
        "#{Cropio::Connection::Configurable::BASE_URL}/#{resource}"
      end
    end
  end
end
