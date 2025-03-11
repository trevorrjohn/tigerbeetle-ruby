require 'tb_client'
require 'tigerbeetle/converters/base'

module TigerBeetle
  module Converters
    class CreateTransfersResult < Base
      def self.native_type
        TBClient::CreateTransfersResult
      end

      def from_native(ptr)
        c_value = TBClient::CreateTransfersResult.new(ptr)
        [c_value[:index], c_value[:result]]
      end

      def to_native(ptr, value)
        raise 'Unexpected conversion of CreateTransfersResult to a native type'
      end
    end
  end
end
