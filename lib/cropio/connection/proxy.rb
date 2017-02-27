module Cropio
  module Connection
    # Encapsulates communication with Cropio API.
    # Proxies calls to API as HTTPS requests.
    class Proxy
      extend Authenticable
      extend Configurable
      extend Proxiable

      authenticate_before :get, :post, :patch, :delete
    end
  end
end
