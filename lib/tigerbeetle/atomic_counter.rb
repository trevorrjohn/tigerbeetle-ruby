module TigerBeetle
  class AtomicCounter
    attr_reader :value

    def initialize(value = 0)
      @value = value
      @mutex = Mutex.new
    end

    def increment
      @mutex.synchronize { @value += 1 }
    end
  end
end
