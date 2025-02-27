module TigerBeetle
  Request = Struct.new(:packet, :response_type, :block) do
    def initialize(packet, response_type, &block)
      super(packet, response_type, block)
    end
  end
end
