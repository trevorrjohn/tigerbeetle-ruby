require 'tb_client'
require 'tigerbeetle/converters/base'

module TigerBeetle
  module Converters
    class CreateAccountsResult < Base
      def self.native_type
        TBClient::CreateAccountsResult
      end

      def from_native(ptr)
        c_value = TBClient::CreateAccountsResult.new(ptr)
        [c_value[:index], c_value[:result]]
      end

      def to_native(ptr, value)
        raise 'Unexpected conversion of CreateAccountsResult to a native type'
      end
    end
  end
end
