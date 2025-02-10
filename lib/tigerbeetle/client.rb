require 'ffi'
require_relative '../../ext/tb_client/tb_client'

module TigerBeetle
  class Client
    def initialize(cluster_id = 0, address = '3000')
      @context = rand(0..1000)
      # Keep a pointer to prevent proc from getting GCed
      @callback = Proc.new { |*args| callback(*args) }
      @client_ptr = FFI::MemoryPointer.new(:uint64, 1)
      cluster_id_ptr = FFI::MemoryPointer.new(:uint64, 2)

      # TODO: Add proper uint128 serialization
      cluster_id_ptr.put_array_of_uint64(0, [cluster_id, 0])

      status = TBClient.tb_client_init(
        @client_ptr,
        cluster_id_ptr,
        address,
        address.length,
        @context,
        &@callback
      )

      raise "Error while initializing client: #{status}" unless status == :SUCCESS
    end

    def lookup_accounts(account_ids)
      account_ids_ptr = FFI::MemoryPointer.new(:uint64, account_ids.length * 2)
      user_data_ptr = FFI::MemoryPointer.new(:uint64, 1)

      account_ids.each_with_index do |id, i|
        # TODO: Add proper uint128 serialization
        account_ids_ptr.put_array_of_uint64(i * 16, [id, 0])
      end

      packet = TBClient::Packet.new
      packet[:user_data] = user_data_ptr
      packet[:operation] = :LOOKUP_ACCOUNTS
      packet[:status] = :OK
      packet[:data_size] = account_ids_ptr.size
      packet[:data] = account_ids_ptr

      TBClient.tb_client_submit(client_ptr.read(:uint64), packet)
    end

    private

    attr_reader :context, :client_ptr

    def callback(context, client, packet, timestamp, result_ptr, result_len)
      p 'CALLBACK RECEIVED!'
      p context
      p client
      p packet
      p timestamp
      p result_ptr
      p result_len
    end
  end
end
