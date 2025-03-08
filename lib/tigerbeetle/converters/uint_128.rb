require 'tb_client'

module TigerBeetle
  module Converters
    module UInt128
      def self.native_type
        TBClient::UInt128
      end

      def self.from_native(ptr)
        c_value = TBClient::UInt128.new(ptr)
        c_value[:low] + (c_value[:high] << 64)
      end

      def self.to_native(ptr, value)
        TBClient::UInt128.new(ptr).tap do |result|
          result[:low] = value % 2**64
          result[:high] = value >> 64
        end
      end
    end
  end
end
