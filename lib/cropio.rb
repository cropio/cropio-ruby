require 'ostruct'
require 'cropio/misc'
require 'cropio/version'
require 'cropio/connection'
require 'cropio/resource'
require 'cropio/resources'

module Cropio
  def self.credentials
    @credentials
  end

  def self.credentials=(credentials)
    case credentials
    when Hash
      @credentials = OpenStruct.new(credentials)
    when OpenStruct
      @credentials = credentials
    else
      fail 'Cropio credentials should be a Hash or OpenStruct.'
    end
  end
end
