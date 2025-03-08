require 'tb_client'
require 'tigerbeetle/account_balance'
require 'tigerbeetle/converters/time'
require 'tigerbeetle/converters/uint_128'

module TigerBeetle
  module Converters
    module AccountBalance
      def self.native_type
        TBClient::AccountBalance
      end

      def self.from_native(ptr)
        c_value = TBClient::AccountBalance.new(ptr)

        TigerBeetle::AccountBalance.new(
          debits_pending: Converters::UInt128.from_native(c_value[:debits_pending].to_ptr),
          debits_posted: Converters::UInt128.from_native(c_value[:debits_posted].to_ptr),
          credits_pending: Converters::UInt128.from_native(c_value[:credits_pending].to_ptr),
          credits_posted: Converters::UInt128.from_native(c_value[:credits_posted].to_ptr),
          timestamp: Converters::Time.from_native(ptr + c_value.offset_of(:timestamp))
        )
      end

      def self.to_native(ptr, value)
        TBClient::AccountBalance.new(ptr).tap do |result|
          Converters::UInt128.to_native(result[:debits_pending].to_ptr, value.debits_pending)
          Converters::UInt128.to_native(result[:debits_posted].to_ptr, value.debits_posted)
          Converters::UInt128.to_native(result[:credits_pending].to_ptr, value.credits_pending)
          Converters::UInt128.to_native(result[:credits_posted].to_ptr, value.credits_posted)
          Converters::Time.to_native(ptr + result.offset_of(:timestamp), value.timestamp || 0)
        end
      end
    end
  end
end
