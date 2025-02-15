require 'securerandom'

module TigerBeetle
  module ID
    @last_time_ms = 0

    # Generates a Universally Unique and Sortable Identifier as a 128-bit integer. Based on ULIDs
    # Inspired by ext/tb_client/tigerbeetle/src/clients/python/src/tigerbeetle/client.py#id
    def self.generate
      rnd_bytes = SecureRandom.random_bytes(10)
      time_ms = (Time.now.to_f * 1000).to_i

      # Ensure time_ms monotonically increases
      if time_ms <= @last_time_ms
        time_ms = @last_time_ms
      else
        @last_time_ms = time_ms
      end

      # Convert time_ms integer to 6 bytes (string) in big-endian
      time_bytes = [time_ms].pack("Q>")[2..7]

      # Combine time and randomness and convert to two 64-bit integers in big-endian
      integers = (time_bytes + rnd_bytes).unpack("Q>Q>")

      # Re-combine into a single 128-bit integer in big-endian
      integers[0] << 64 | integers[1]
    end
  end
end
