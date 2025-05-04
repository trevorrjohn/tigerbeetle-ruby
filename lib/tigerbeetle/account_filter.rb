module TigerBeetle
  ACCOUNT_FILTER_PARAMS = %i[
    account_id user_data_128 user_data_64 user_data_32 code timestamp_min timestamp_max limit flags
  ]

  AccountFilter = Struct.new(*ACCOUNT_FILTER_PARAMS) do
    def initialize(
      account_id:,
      user_data_128: 0,
      user_data_64: 0,
      user_data_32: 0,
      code: 0,
      timestamp_min: 0,
      timestamp_max: 0,
      limit:,
      flags: []
    )
      super(
        account_id,
        user_data_128,
        user_data_64,
        user_data_32,
        code,
        timestamp_min,
        timestamp_max,
        limit,
        flags
      )
    end
  end
end
