module TigerBeetle
  ACCOUNT_PARAMS = %i[
    id debits_pending debits_posted credits_pending credits_posted user_data_128
    user_data_64 user_data_32 ledger code flags timestamp
  ]

  Account = Struct.new(*ACCOUNT_PARAMS) do
    def initialize(
      id:,
      debits_pending: 0,
      debits_posted: 0,
      credits_pending: 0,
      credits_posted: 0,
      user_data_128: 0,
      user_data_64: 0,
      user_data_32: 0,
      ledger:,
      code:,
      flags: [],
      timestamp: nil
    )
      super(
        id,
        debits_pending,
        debits_posted,
        credits_pending,
        credits_posted,
        user_data_128,
        user_data_64,
        user_data_32,
        ledger,
        code,
        flags,
        timestamp
      )
    end
  end
end
