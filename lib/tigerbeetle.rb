require 'tigerbeetle/id'
require 'tigerbeetle/version'

module TigerBeetle
  def self.id
    ID.generate
  end
end
