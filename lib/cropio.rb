require 'ostruct'
require "cropio/version"

module Cropio
  def credentials
    @credentials
  end

  def credentials=(credentials)
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
