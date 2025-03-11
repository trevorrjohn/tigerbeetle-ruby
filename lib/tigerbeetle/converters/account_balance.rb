require 'tb_client'
require 'tigerbeetle/account_balance'
require 'tigerbeetle/converters/base'
require 'tigerbeetle/converters/time'
require 'tigerbeetle/converters/uint_128'

module TigerBeetle
  module Converters
    class AccountBalance < Base
      def self.native_type
        TBClient::AccountBalance
      end

      def from_native(ptr)
        c_value = TBClient::AccountBalance.new(ptr)

        TigerBeetle::AccountBalance.new(
          debits_pending: Converters::UInt128.from_native(c_value[:debits_pending].to_ptr),
          debits_posted: Converters::UInt128.from_native(c_value[:debits_posted].to_ptr),
          credits_pending: Converters::UInt128.from_native(c_value[:credits_pending].to_ptr),
          credits_posted: Converters::UInt128.from_native(c_value[:credits_posted].to_ptr),
          timestamp: Converters::Time.from_native(ptr + c_value.offset_of(:timestamp))
        )
      end

      def to_native(ptr, value)
        raise 'Unexpected conversion of AccountBalance to native type'
      end
    end
  end
end
