require'rest-client'

class Cropio::Connection::Proxy
  extend Configurable
  extend Authenticable
  extend Proxiable
end
