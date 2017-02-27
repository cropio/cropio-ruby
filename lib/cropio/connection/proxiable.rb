require 'rest-client'

module Cropio
  module Connection
    # Contains logic of proxing calls to HTTPS requests.
    module Proxiable
      # Accepts reources name and params to perform HTTPS GET request.
      def get(resource, query = {})
        proxy(method: :get, url: url_for(resource), headers: { params: query })
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

      def changes(resource, query = {})
        proxy(method: :get,
              url: url_for_changes(resource,
                                   query[:from_time], query[:to_time]),
              headers: { params: query })
      end

      protected

      def url_for(resource)
        "#{Cropio::Connection::Configurable::BASE_URL}/#{resource}"
      end

      def url_for_changes(resource, from_time, to_time)
        params = url_changes_params(from_time, to_time)
        "#{Cropio::Connection::Configurable::BASE_URL}/"\
        "#{resource}/changes?#{params}"
      end

      def url_changes_params(from_time, to_time)
        "from_time=#{from_time}&to_time=#{to_time}"
      end

      def proxy(options)
        options[:headers] ||= {}
        options[:headers].merge!(headers)
        res = send("proxy_#{options[:method]}", options)
        options[:method].eql?(:delete) ? res : JSON.parse(res)
      rescue RestClient::UnprocessableEntity => e
        puts JSON.parse(e.http_body)
        raise e
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
