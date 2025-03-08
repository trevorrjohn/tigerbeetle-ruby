module TigerBeetle
  Request = Struct.new(:packet, :converter, :block) do
    def initialize(packet, converter, &block)
      super(packet, converter, block)
    end
  end
end
