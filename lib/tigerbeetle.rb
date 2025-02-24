require 'tigerbeetle/client'
require 'tigerbeetle/id'
require 'tigerbeetle/version'

module TigerBeetle
  def self.id
    ID.generate
  end

  def self.connect(cluster_id = 0, address = '3000')
    TigerBeetle::Client.new(cluster_id, address)
  end
end
