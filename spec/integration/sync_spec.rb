require 'tigerbeetle/client'

describe 'Integration tests for a sync client' do
  let(:client) { TigerBeetle::Client.new } # assume TB is running on localhost:3000
  let(:ledger) { 111 }

  describe 'create_accounts' do
    it 'creates a new account' do
      response = client.create_accounts(TigerBeetle::Account.new(id: 100, ledger: ledger, code: 1))

      expect(response).to be_empty
    end

    it 'creates an existing account' do
      account = TigerBeetle::Account.new(id: 102, ledger: ledger, code: 1)

      client.create_accounts(account)
      response = client.create_accounts(account)

      expect(response[0][:result]).to eq(:EXISTS)
    end
  end

  describe 'create_transfers' do
    before do
      client.create_accounts(TigerBeetle::Account.new(id: 103, ledger: ledger, code: 1))
      client.create_accounts(TigerBeetle::Account.new(id: 104, ledger: ledger, code: 1))
    end

    it 'creates a transfer between accounts' do
      transfer = TigerBeetle::Transfer.new(
        id: 100,
        debit_account_id: 103,
        credit_account_id: 104,
        amount: 999,
        ledger: ledger,
        code: 1
      )
      response = client.create_transfers(transfer)

      expect(response).to be_empty

      account_1, account_2 = client.lookup_accounts(103, 104)

      expect(account_1[:debits_posted].to_i).to eq(999)
      expect(account_1[:credits_posted].to_i).to eq(0)
      expect(account_2[:debits_posted].to_i).to eq(0)
      expect(account_2[:credits_posted].to_i).to eq(999)
    end
  end

  describe 'lookup_accounts' do
    before { client.create_accounts(TigerBeetle::Account.new(id: 105, ledger: ledger, code: 1)) }

    it 'returns account info' do
      response = client.lookup_accounts(105)

      expect(response.length).to eq(1)
      expect(response[0]).to be_a(TBClient::Account)
      expect(response[0][:id].to_i).to eq(105)
      expect(response[0][:ledger]).to eq(ledger)
      expect(response[0][:code]).to eq(1)
    end
  end

  describe 'lookup_transfers' do
    before do
      client.create_accounts(TigerBeetle::Account.new(id: 106, ledger: ledger, code: 1))
      client.create_accounts(TigerBeetle::Account.new(id: 107, ledger: ledger, code: 1))
      client.create_transfers(TigerBeetle::Transfer.new(
        id: 101,
        debit_account_id: 106,
        credit_account_id: 107,
        amount: 111,
        ledger: ledger,
        code: 1
      ))
      client.create_transfers(TigerBeetle::Transfer.new(
        id: 102,
        debit_account_id: 107,
        credit_account_id: 106,
        amount: 222,
        ledger: ledger,
        code: 1
      ))
    end

    it 'returns transfer details' do
      response = client.lookup_transfers(101, 102)
      expect(response.length).to eq(2)

      transfer_1, transfer_2 = response
      expect(transfer_1[:id].to_i).to eq(101)
      expect(transfer_1[:debit_account_id].to_i).to eq(106)
      expect(transfer_1[:credit_account_id].to_i).to eq(107)
      expect(transfer_1[:amount].to_i).to eq(111)

      expect(transfer_2[:id].to_i).to eq(102)
      expect(transfer_2[:debit_account_id].to_i).to eq(107)
      expect(transfer_2[:credit_account_id].to_i).to eq(106)
      expect(transfer_2[:amount].to_i).to eq(222)
    end
  end

  describe 'get_account_transfers' do

  end

  describe 'get_account_balances' do

  end

  describe 'query_accounts' do

  end

  describe 'query_transfers' do

  end
end
