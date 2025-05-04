require 'tigerbeetle/atomic_counter'

describe TigerBeetle::AtomicCounter do
  describe '#increment' do
    it 'increments the value by 1 and returns it' do
      expect(subject.increment).to eq(1)
      expect(subject.increment).to eq(2)
      expect(subject.increment).to eq(3)
    end
  end
end
