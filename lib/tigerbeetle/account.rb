module TigerBeetle
  ACCOUNT_PARAMS = %i[
    id debits_pending debits_posted credits_pending credits_posted user_data_128 user_data_64
    user_data_32 reserved ledger code flags timestamp
  ]

  Account = Struct.new(*ACCOUNT_PARAMS) do
    def initialize(
      id: 0,
      debits_pending: 0,
      debits_posted: 0,
      credits_pending: 0,
      credits_posted: 0,
      user_data_128: 0,
      user_data_64: 0,
      user_data_32: 0,
      reserved: 0,
      ledger: 0,
      code: 0,
      flags: 0,
      timestamp: 0
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
        reserved,
        ledger,
        code,
        flags,
        timestamp
      )
    end
  end
end
