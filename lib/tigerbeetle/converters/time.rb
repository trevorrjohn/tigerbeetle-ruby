require 'ffi'
require 'tigerbeetle/converters/base'

module TigerBeetle
  module Converters
    class Time < Base
      def self.native_type
        FFI::Type::UINT64
      end

      def from_native(ptr)
        ::Time.at(ptr.read(FFI::Type::UINT64) / 1e9)
      end

      def to_native(ptr, value)
        int = (value.to_f * 1e9).to_i
        validate_uint!(:timestamp, 64, int)

        ptr.write(FFI::Type::UINT64, int)
      end
    end
  end
end
