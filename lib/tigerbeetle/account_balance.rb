module TigerBeetle
  ACCOUNT_BALANCE_PARAMS = %i[
    debits_pending debits_posted credits_pending credits_posted timestamp
  ]

  AccountBalance = Struct.new(*ACCOUNT_BALANCE_PARAMS) do
    def initialize(
      debits_pending: 0,
      debits_posted: 0,
      credits_pending: 0,
      credits_posted: 0,
      timestamp: 0
    )
      super(
        debits_pending,
        debits_posted,
        credits_pending,
        credits_posted,
        timestamp
      )
    end
  end
end
