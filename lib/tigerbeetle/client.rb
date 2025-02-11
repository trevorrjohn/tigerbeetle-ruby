require 'ffi'
require_relative '../../ext/tb_client/tb_client'

module TigerBeetle
  class Client
    def initialize(cluster_id = 0, address = '3000')
      @inflight_requests = {}
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

    def lookup_accounts(*account_ids)
      queue = Queue.new

      submit_request(
        :LOOKUP_ACCOUNTS,
        account_ids,
        TBClient::UInt128,
        TBClient::Account
      ) do |response|
        queue << response
      end

      # block until the request is processed and return it
      queue.pop
    end

    private

    attr_reader :context, :client_ptr, :inflight_requests

    def callback(context, client, packet, timestamp, result_ptr, result_len)
      p 'CALLBACK RECEIVED!'
      p context
      p client
      p packet
      p timestamp
      p result_ptr
      p result_len

      p inflight_requests[packet[:user_data].read_uint64]
      inflight_requests[packet[:user_data].read_uint64][1].call(result_ptr)
    end

    def submit_request(operation, request, request_type, response_type, &block)
      user_data_ptr = FFI::MemoryPointer.new(:uint64, 1)
      user_data_ptr.write_uint64(123)

      data_ptr = FFI::MemoryPointer.new(request_type, request.length, true)
      request.each_with_index do |value, i|
        instance = request_type.new(data_ptr[i]) # initialize new type over the new memory
        instance.from(value) # write values into the memory
      end

      packet = TBClient::Packet.new
      packet[:user_data] = user_data_ptr
      packet[:operation] = operation
      packet[:status] = :OK
      packet[:data_size] = data_ptr.size
      packet[:data] = data_ptr

      inflight_requests[123] = [packet, block, response_type]

      TBClient.tb_client_submit(client_ptr.read(:uint64), packet)
    end
  end
end
