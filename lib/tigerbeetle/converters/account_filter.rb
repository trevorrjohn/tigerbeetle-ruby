require 'tb_client'
require 'tigerbeetle/account_filter'
require 'tigerbeetle/converters/time'
require 'tigerbeetle/converters/uint_128'

module TigerBeetle
  module Converters
    module AccountFilter
      def self.native_type
        TBClient::AccountFilter
      end

      def self.from_native(ptr)
        c_value = TBClient::AccountFilter.new(ptr)

        TigerBeetle::AccountFilter.new(
          account_id: Converters::UInt128.from_native(c_value[:account_id].to_ptr),
          user_data_128: Converters::UInt128.from_native(c_value[:user_data_128].to_ptr),
          user_data_64: c_value[:user_data_64],
          user_data_32: c_value[:user_data_32],
          code: c_value[:code],
          timestamp_min: Converters::Time.from_native(ptr + c_value.offset_of(:timestamp_min)),
          timestamp_max: Converters::Time.from_native(ptr + c_value.offset_of(:timestamp_max)),
          limit: c_value[:limit],
          flags: c_value[:flags]
        )
      end

      def self.to_native(ptr, value)
        TBClient::AccountFilter.new(ptr).tap do |result|
          Converters::UInt128.to_native(result[:account_id].to_ptr, value.account_id)
          Converters::UInt128.to_native(result[:user_data_128].to_ptr, value.user_data_128)
          result[:user_data_64] = value.user_data_64
          result[:user_data_32] = value.user_data_32
          result[:code] = value.code
          Converters::Time.to_native(ptr + result.offset_of(:timestamp_min), value.timestamp_min || 0)
          Converters::Time.to_native(ptr + result.offset_of(:timestamp_max), value.timestamp_max || 0)
          result[:limit] = value.limit
          result[:flags] = value.flags
        end
      end
    end
  end
end
