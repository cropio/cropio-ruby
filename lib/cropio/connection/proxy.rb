module Cropio
  module Connection
    class Proxy
      extend Authenticable
      extend Configurable
      extend Proxiable

      authenticate_before :get, :post, :patch, :delete
    end
  end
end
