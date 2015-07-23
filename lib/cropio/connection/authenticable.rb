module Cropio
  module Connection
    module Authenticable
      def authenticate!
        auth_request
      end

      protected

      def authenticate_before(*methods)
        methods.each do |method_name|
          unauthentificated_method = method(method_name)
          singleton_class.send(:define_method, method_name) do |*args|
            authenticate! if !authenticated?
            unauthentificated_method.call(*args)
          end
        end
      end

      def auth_request
        process_result RestClient.post(url_for('sign_in'),
                                  auth_request_params.to_json,
                                  authentication_headers)
      rescue RestClient::Unauthorized => e
        rocess_result(e.http_body)
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
      rescue NoMethodError => e
        if %i(email password).include?(e.name)
          fail "Cropio credentials is not specified: #{e.name}"
        else
          raise e
        end
      end

      def authenticated?
        !Cropio.credentials.api_token.nil?
      rescue NoMethodError => e
        e.name == :api_token ? false : raise(e)
      end
    end
  end
end
