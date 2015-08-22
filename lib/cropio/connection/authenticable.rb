module Cropio
  module Connection
    # Contains authentication options for connection.
    module Authenticable
      # Public interface for authentication request
      def authenticate!
        auth_request
      end

      protected

      # Define wrappers around specified methods to be sure
      # they are authenticated.
      def authenticate_before(*methods)
        methods.each do |method_name|
          unauthentificated_method = method(method_name)
          singleton_class.send(:define_method, method_name) do |*args|
            authenticate! unless authenticated?
            unauthentificated_method.call(*args)
          end
        end
      end

      # Send authentication request.
      def auth_request
        process_result RestClient.post(url_for('sign_in'),
                                       auth_request_params.to_json,
                                       authentication_headers)
      rescue RestClient::Unauthorized => e
        process_result(e.http_body)
      end

      # Process result returned by authentication request.
      def process_result(result)
        result = JSON.parse(result)

        if result['success']
          Cropio.credentials.api_token = result['user_api_token']
          true
        else
          fail 'Access to Cropio denied.'
        end
      end

      # Return params based on user credentials.
      def auth_request_params
        {
          user_login: {
            email: Cropio.credentials.email,
            password: Cropio.credentials.password
          }
        }
      rescue NoMethodError => e
        process_auth_params_error(e) || raise(e)
      end

      # Returns true if user has api token.
      def authenticated?
        !Cropio.credentials.api_token.nil?
      rescue NoMethodError => e
        e.name == :api_token ? false : raise(e)
      end

      # Process NoMethodError and prints norification if
      # exeption was produced by empty credentials.
      def process_auth_params_error(e)
        return unless %i(email password).include?(e.name)
        fail "Cropio credentials is not specified: #{e.name}"
      end
    end
  end
end
