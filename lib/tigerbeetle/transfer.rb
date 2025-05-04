module TigerBeetle
  TRANSFER_PARAMS = %i[
    id debit_account_id credit_account_id amount pending_id user_data_128
    user_data_64 user_data_32 timeout ledger code flags timestamp
  ]

  Transfer = Struct.new(*TRANSFER_PARAMS) do
    def initialize(
      id:,
      debit_account_id: 0,
      credit_account_id: 0,
      amount: 0,
      pending_id: 0,
      user_data_128: 0,
      user_data_64: 0,
      user_data_32: 0,
      timeout: 0,
      ledger: 0,
      code: 0,
      flags: [],
      timestamp: nil
    )
      super(
        id,
        debit_account_id,
        credit_account_id,
        amount,
        pending_id,
        user_data_128,
        user_data_64,
        user_data_32,
        timeout,
        ledger,
        code,
        flags,
        timestamp
      )
    end
  end
end
