module TigerBeetle
  module Converters
    class Base
      def self.from_native(ptr)
        self.new.from_native(ptr)
      end

      def self.to_native(ptr, value)
        self.new.to_native(ptr, value)
      end

      def self.native_type
        raise NotImplementedError, 'Implement in sublcass'
      end

      def from_native(ptr)
        raise NotImplementedError, 'Implement in sublcass'
      end

      def to_native(ptr, value)
        raise NotImplementedError, 'Implement in sublcass'
      end

      private

      def validate_uint!(name, bits, value)
        if value > 2**bits - 1
          raise ArgumentError, "#{name} == #{value} is too large to fit in #{bits} bits"
        elsif value < 0
          raise ArgumentError, "#{name} == #{value} cannot be negative"
        end
      end
    end
  end
end
