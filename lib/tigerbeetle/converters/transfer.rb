require 'tb_client'
require 'tigerbeetle/transfer'
require 'tigerbeetle/converters/base'
require 'tigerbeetle/converters/time'
require 'tigerbeetle/converters/uint_128'

module TigerBeetle
  module Converters
    class Transfer < Base
      def self.native_type
        TBClient::Transfer
      end

      def from_native(ptr)
        c_value = TBClient::Transfer.new(ptr)

        TigerBeetle::Transfer.new(
          id: Converters::UInt128.from_native(c_value[:id].to_ptr),
          debit_account_id: Converters::UInt128.from_native(c_value[:debit_account_id].to_ptr),
          credit_account_id: Converters::UInt128.from_native(c_value[:credit_account_id].to_ptr),
          amount: Converters::UInt128.from_native(c_value[:amount].to_ptr),
          pending_id: Converters::UInt128.from_native(c_value[:pending_id].to_ptr),
          user_data_128: Converters::UInt128.from_native(c_value[:user_data_128].to_ptr),
          user_data_64: c_value[:user_data_64],
          user_data_32: c_value[:user_data_32],
          timeout: c_value[:timeout],
          ledger: c_value[:ledger],
          code: c_value[:code],
          flags: c_value[:flags],
          timestamp: Converters::Time.from_native(ptr + c_value.offset_of(:timestamp))
        )
      end

      def to_native(ptr, value)
        validate_uint!(:id, 128, value.id)
        validate_uint!(:debit_account_id, 128, value.debit_account_id)
        validate_uint!(:credit_account_id, 128, value.credit_account_id)
        validate_uint!(:amount, 128, value.amount)
        validate_uint!(:user_data_128, 128, value.user_data_128)
        validate_uint!(:user_data_64, 64, value.user_data_64)
        validate_uint!(:user_data_32, 32, value.user_data_32)
        validate_uint!(:timeout, 32, value.timeout)
        validate_uint!(:ledger, 32, value.ledger)
        validate_uint!(:code, 16, value.code)

        TBClient::Transfer.new(ptr).tap do |result|
          Converters::UInt128.to_native(result[:id].to_ptr, value.id)
          Converters::UInt128.to_native(result[:debit_account_id].to_ptr, value.debit_account_id)
          Converters::UInt128.to_native(result[:credit_account_id].to_ptr, value.credit_account_id)
          Converters::UInt128.to_native(result[:amount].to_ptr, value.amount)
          Converters::UInt128.to_native(result[:pending_id].to_ptr, value.pending_id)
          Converters::UInt128.to_native(result[:user_data_128].to_ptr, value.user_data_128)
          result[:user_data_64] = value.user_data_64
          result[:user_data_32] = value.user_data_32
          result[:timeout] = value.timeout
          result[:ledger] = value.ledger
          result[:code] = value.code
          result[:flags] = value.flags
          Converters::Time.to_native(ptr + result.offset_of(:timestamp), value.timestamp || 0)
        end
      end
    end
  end
end
