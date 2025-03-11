require 'tb_client'
require 'tigerbeetle/converters/base'

module TigerBeetle
  module Converters
    class UInt128 < Base
      def self.native_type
        TBClient::UInt128
      end

      def from_native(ptr)
        c_value = TBClient::UInt128.new(ptr)
        c_value[:low] + (c_value[:high] << 64)
      end

      def to_native(ptr, value)
        TBClient::UInt128.new(ptr).tap do |result|
          result[:low] = value % 2**64
          result[:high] = value >> 64
        end
      end
    end
  end
end
