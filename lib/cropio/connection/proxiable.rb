require 'rest-client'

module Cropio
  module Connection
    # Contains logic of proxing calls to HTTPS requests.
    module Proxiable
      # Accepts resources name and params to perform HTTPS GET request.
      def get(resource, query = {})
        rmethod = extract_resource_method!(query)
        id = extract_record_id!(query)

        proxy(method: :get, url: url_for(resource, rmethod, id),
                            headers: { params: query })
      end

      # Accepts resources name and params to perform HTTPS POST request.
      def post(resource, data)
        proxy(method: :post, url: url_for(resource), data: data)
      end

      # Accepts resources name and params to perform HTTPS PATCH request.
      def patch(resource, data)
        proxy(method: :patch, url: url_for(resource), data: data)
      end

      # Accepts resources name and params to perform HTTPS DELETE request.
      def delete(resource)
        proxy(method: :delete, url: url_for(resource))
      end

      protected

      def url_for(resource, resource_method = nil, id = nil)
        url = resolve_api_url(resource)
        url += "/#{resource_method}" if resource_method
        url += "/#{id}" if id
        url
      end

      def resolve_api_url(resource)
        Cropio::Connection::Configurable::BASE_URL +
          (resource == 'weather_history_items' ? 'a' : '') +
          "/#{resource}"
      end

      def extract_resource_method!(query)
        raise ArgumentError unless query.is_a?(Hash)

        query.delete(:resource_method)
      end

      def extract_record_id!(query)
        raise ArgumentError unless query.is_a?(Hash)

        query.delete(:id)
      end

      def proxy(options)
        options[:headers] ||= {}
        options[:headers].merge!(headers)
        clear_params_in_options!(options)
        res = send("proxy_#{options[:method]}", options)
        options[:method].eql?(:delete) ? res : JSON.parse(res)
      rescue RestClient::UnprocessableEntity => e
        puts JSON.parse(e.http_body)
        raise e
      rescue RestClient::NotFound
        {}
      end

      def clear_params_in_options!(options)
        return if options[:headers][:params].nil?

        options[:headers][:params].reject! { |_k, v| v.nil? }
      end

      def proxy_get(options)
        RestClient::Request.execute(options)
      end

      def proxy_post(options)
        RestClient.post(options[:url],
                        { data: options[:data] }, options[:headers])
      end

      def proxy_patch(options)
        RestClient.patch(options[:url],
                         { data: options[:data] }, options[:headers])
      end

      def proxy_delete(options)
        RestClient.delete(options[:url], options[:headers])
      end
    end
  end
end
