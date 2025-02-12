module TigerBeetle
  QUERY_FILTER_PARAMS = %i[
    user_data_128 user_data_64 user_data_32 ledger code timestamp_min timestamp_max limit flags
  ]

  QueryFilter = Struct.new(*QUERY_FILTER_PARAMS) do
    def initialize(
      user_data_128: 0,
      user_data_64: 0,
      user_data_32: 0,
      ledger: 0,
      code: 0,
      timestamp_min: 0,
      timestamp_max: 0,
      limit: 0,
      flags: 0
    )
      super(
        user_data_128,
        user_data_64,
        user_data_32,
        ledger,
        code,
        timestamp_min,
        timestamp_max,
        limit,
        flags
      )
    end
  end
end
