require 'ostruct'
require 'cropio/misc'
require 'cropio/version'
require 'cropio/connection'
require 'cropio/resource'
require 'cropio/resources'

# Cropio-Ruby provides simple ActiveRecord-like wrappings
# for Cropio API. Currently it supports Cropio APIv3.
#
# Main gem's module Cropio contains accessors for credentials and other stuff
module Cropio
  # Getter for credentials
  def self.credentials
    @credentials
  end

  # Setter for credentials,
  # accepts Hash or OpenStruct with email and password or api_token
  # as param
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
