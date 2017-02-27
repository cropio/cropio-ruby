require 'rest-client'

module Cropio
  module Connection
    # Contains logic of proxing calls to HTTPS requests.
    module Proxiable
      # Accepts reources name and params to perform HTTPS GET request.
      def get(resource, query = {})
        rmethod = extract_resource_method!(query)
        proxy(method: :get, url: url_for(resource, rmethod),
                            headers: { params: query })
      end

      # Accepts reources name and params to perform HTTPS POST request.
      def post(resource, data)
        proxy(method: :post, url: url_for(resource), data: data)
      end

      # Accepts reources name and params to perform HTTPS PATCH request.
      def patch(resource, data)
        proxy(method: :patch, url: url_for(resource), data: data)
      end

      # Accepts reources name and params to perform HTTPS DELETE request.
      def delete(resource)
        proxy(method: :delete, url: url_for(resource))
      end

      protected

      def url_for(resource, resource_method = nil)
        url = "#{Cropio::Connection::Configurable::BASE_URL}/#{resource}"
        url += "/#{resource_method}" if resource_method
        url
      end

      def url_for_changes(resource, from_time, to_time)
        params = url_changes_params(from_time, to_time)
        "#{Cropio::Connection::Configurable::BASE_URL}/"\
        "#{resource}/changes?#{params}"
      end

      def url_changes_params(from_time, to_time)
        "from_time=#{from_time}&to_time=#{to_time}"
      end

      def extract_resource_method!(query)
        fail(ArgumentError) unless query.is_a?(Hash)
        query.delete(:resource_method)
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
