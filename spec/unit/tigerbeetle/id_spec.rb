require 'tigerbeetle/id'

describe TigerBeetle::ID do
  it 'generates a ULID' do
    id = described_class.generate

    expect(id.bit_length).to be > 120
    expect(id.bit_length).to be <= 128
  end

  it 'generates same output as Python client' do
    described_class.instance_variable_set(:@last_time_ms, 0)

    allow(SecureRandom)
      .to receive(:random_bytes)
      .with(10)
      .and_return("Q\x96\x02\xF3iU\xDC\xBF:\x8C".force_encoding('binary'))
    allow(Time).to receive(:now).and_return(Time.at(1739655562, 697795000, :nsec))

    id = described_class.generate

    expect(id).to eq(2103114526981004915525818251529370252)
  end
end
