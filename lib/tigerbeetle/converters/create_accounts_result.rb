require 'tb_client'

module TigerBeetle
  module Converters
    module CreateAccountsResult
      def self.native_type
        TBClient::CreateAccountsResult
      end

      def self.from_native(ptr)
        c_value = TBClient::CreateAccountsResult.new(ptr)
        [c_value[:index], c_value[:result]]
      end

      def self.to_native(ptr, value)
        raise 'unexpected invocation'
      end
    end
  end
end
