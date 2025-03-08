require 'ffi'

module TigerBeetle
  module Converters
    module Time
      def self.native_type
        FFI::Type::UINT64
      end

      def self.from_native(ptr)
        ::Time.at(ptr.read(FFI::Type::UINT64) / 1e9)
      end

      def self.to_native(ptr, value)
        int = (value.to_f * 1e9).to_i
        ptr.write(FFI::Type::UINT64, int)
      end
    end
  end
end
