require 'tigerbeetle'

describe 'Integration tests for a sync client' do
  let(:client) { @client }
  let(:ledger) { 111 }
  let(:code) { 10 }
  let(:id) { TigerBeetle::ID.generate }

  # assume TB is running on localhost:3000
  before(:all) { @client = TigerBeetle.connect }
  after(:all) { @client.deinit }

  describe 'create_accounts' do
    it 'creates a new account' do
      response = client.create_accounts(TigerBeetle::Account.new(id:, ledger:, code:))

      expect(response).to be_empty
    end

    it 'creates an existing account' do
      account = TigerBeetle::Account.new(id:, ledger:, code:)

      client.create_accounts(account)
      response = client.create_accounts(account)

      expect(response[0][:result]).to eq(:EXISTS)
    end
  end

  describe 'create_transfers' do
    let(:id_1) { TigerBeetle::ID.generate }
    let(:id_2) { TigerBeetle::ID.generate }

    before do
      client.create_accounts(
        TigerBeetle::Account.new(id: id_1, ledger:, code:),
        TigerBeetle::Account.new(id: id_2, ledger:, code:)
      )
    end

    it 'creates a transfer between accounts' do
      transfer = TigerBeetle::Transfer.new(
        id: TigerBeetle::ID.generate,
        debit_account_id: id_1,
        credit_account_id: id_2,
        amount: 999,
        ledger:,
        code:
      )
      response = client.create_transfers(transfer)

      expect(response).to be_empty

      account_1, account_2 = client.lookup_accounts(id_1, id_2)

      expect(account_1[:debits_posted].to_i).to eq(999)
      expect(account_1[:credits_posted].to_i).to eq(0)
      expect(account_2[:debits_posted].to_i).to eq(0)
      expect(account_2[:credits_posted].to_i).to eq(999)
    end
  end

  describe 'lookup_accounts' do
    before { client.create_accounts(TigerBeetle::Account.new(id:, ledger:, code:)) }

    it 'returns account info' do
      response = client.lookup_accounts(id)

      expect(response.length).to eq(1)
      expect(response[0]).to be_a(TBClient::Account)
      expect(response[0][:id].to_i).to eq(id)
      expect(response[0][:ledger]).to eq(ledger)
      expect(response[0][:code]).to eq(code)
    end
  end

  describe 'lookup_transfers' do
    let(:ids) { Array.new(4) { TigerBeetle::ID.generate } }

    before do
      client.create_accounts(
        TigerBeetle::Account.new(id: ids[0], ledger:, code:),
        TigerBeetle::Account.new(id: ids[1], ledger:, code:)
      )
      client.create_transfers(
        TigerBeetle::Transfer.new(
          id: ids[2],
          debit_account_id: ids[0],
          credit_account_id: ids[1],
          amount: 111,
          ledger:,
          code:
        ),
        TigerBeetle::Transfer.new(
          id: ids[3],
          debit_account_id: ids[1],
          credit_account_id: ids[0],
          amount: 222,
          ledger:,
          code:
        )
      )
    end

    it 'returns transfer details' do
      response = client.lookup_transfers(ids[2], ids[3])
      expect(response.length).to eq(2)

      transfer_1, transfer_2 = response
      expect(transfer_1[:id].to_i).to eq(ids[2])
      expect(transfer_1[:debit_account_id].to_i).to eq(ids[0])
      expect(transfer_1[:credit_account_id].to_i).to eq(ids[1])
      expect(transfer_1[:amount].to_i).to eq(111)

      expect(transfer_2[:id].to_i).to eq(ids[3])
      expect(transfer_2[:debit_account_id].to_i).to eq(ids[1])
      expect(transfer_2[:credit_account_id].to_i).to eq(ids[0])
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
