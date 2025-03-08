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

    it 'fails to create a duplicate account' do
      account = TigerBeetle::Account.new(id:, ledger:, code:)

      client.create_accounts(account)
      response = client.create_accounts(account)

      expect(response[0]).to eq([0, :EXISTS])
    end

    it 'creates accounts asynchronously' do
      ids = Array.new(10) { TigerBeetle::ID.generate }

      queue = Queue.new
      ids.each do |id|
        response = client.create_accounts(TigerBeetle::Account.new(id:, ledger:, code:)) do |_|
          queue << id
        end

        expect(response).to eq(nil)
      end

      completed = []
      10.times { completed << queue.pop }

      expect(completed).to match_array(ids)
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
      expect(response[0]).to be_a(TigerBeetle::Account)
      expect(response[0].id).to eq(id)
      expect(response[0].ledger).to eq(ledger)
      expect(response[0].code).to eq(code)
    end
  end

  describe 'lookup_transfers' do
    let(:account_ids) { Array.new(2) { TigerBeetle::ID.generate } }
    let(:transfer_ids) { Array.new(2) { TigerBeetle::ID.generate } }

    before do
      client.create_accounts(
        TigerBeetle::Account.new(id: account_ids[0], ledger:, code:),
        TigerBeetle::Account.new(id: account_ids[1], ledger:, code:)
      )
      client.create_transfers(
        TigerBeetle::Transfer.new(
          id: transfer_ids[0],
          debit_account_id: account_ids[0],
          credit_account_id: account_ids[1],
          amount: 111,
          ledger:,
          code:
        ),
        TigerBeetle::Transfer.new(
          id: transfer_ids[1],
          debit_account_id: account_ids[1],
          credit_account_id: account_ids[0],
          amount: 222,
          ledger:,
          code:
        )
      )
    end

    it 'returns transfer details' do
      response = client.lookup_transfers(transfer_ids[0], transfer_ids[1])
      expect(response.length).to eq(2)

      transfer_1, transfer_2 = response
      expect(transfer_1[:id].to_i).to eq(transfer_ids[0])
      expect(transfer_1[:debit_account_id].to_i).to eq(account_ids[0])
      expect(transfer_1[:credit_account_id].to_i).to eq(account_ids[1])
      expect(transfer_1[:amount].to_i).to eq(111)

      expect(transfer_2[:id].to_i).to eq(transfer_ids[1])
      expect(transfer_2[:debit_account_id].to_i).to eq(account_ids[1])
      expect(transfer_2[:credit_account_id].to_i).to eq(account_ids[0])
      expect(transfer_2[:amount].to_i).to eq(222)
    end
  end

  describe 'get_account_transfers' do
    let(:account_ids) { Array.new(3) { TigerBeetle::ID.generate } }
    let(:transfer_ids) { Array.new(3) { TigerBeetle::ID.generate } }

    before do
      client.create_accounts(
        TigerBeetle::Account.new(id: account_ids[0], ledger:, code:),
        TigerBeetle::Account.new(id: account_ids[1], ledger:, code:),
        TigerBeetle::Account.new(id: account_ids[2], ledger:, code:)
      )
      client.create_transfers(
        TigerBeetle::Transfer.new(
          id: transfer_ids[0],
          debit_account_id: account_ids[0],
          credit_account_id: account_ids[1],
          amount: 111,
          ledger:,
          code:
        ),
        TigerBeetle::Transfer.new(
          id: transfer_ids[1],
          debit_account_id: account_ids[1],
          credit_account_id: account_ids[2],
          amount: 222,
          ledger:,
          code:
        ),
        TigerBeetle::Transfer.new(
          id: transfer_ids[2],
          debit_account_id: account_ids[2],
          credit_account_id: account_ids[0],
          amount: 333,
          ledger:,
          code:
        )
      )
    end

    it 'returns account transfers' do
      filter = TigerBeetle::AccountFilter.new(
        account_id: account_ids[0],
        limit: 10,
        flags: [:DEBITS, :CREDITS]
      )
      response = client.get_account_transfers(filter)
      expect(response.length).to eq(2)

      transfer_1, transfer_2 = response
      expect(transfer_1[:id].to_i).to eq(transfer_ids[0])
      expect(transfer_1[:debit_account_id].to_i).to eq(account_ids[0])
      expect(transfer_1[:credit_account_id].to_i).to eq(account_ids[1])
      expect(transfer_1[:amount].to_i).to eq(111)

      expect(transfer_2[:id].to_i).to eq(transfer_ids[2])
      expect(transfer_2[:debit_account_id].to_i).to eq(account_ids[2])
      expect(transfer_2[:credit_account_id].to_i).to eq(account_ids[0])
      expect(transfer_2[:amount].to_i).to eq(333)
    end
  end

  describe 'get_account_balances' do
    let(:account_ids) { Array.new(2) { TigerBeetle::ID.generate } }

    before do
      client.create_accounts(
        TigerBeetle::Account.new(id: account_ids[0], ledger:, code:, flags: [:HISTORY]),
        TigerBeetle::Account.new(id: account_ids[1], ledger:, code:, flags: [:HISTORY]),
      )
      client.create_transfers(
        TigerBeetle::Transfer.new(
          id: id,
          debit_account_id: account_ids[0],
          credit_account_id: account_ids[1],
          amount: 111,
          ledger:,
          code:
        )
      )
    end

    it 'returns account balances' do
      filter = TigerBeetle::AccountFilter.new(
        account_id: account_ids[0],
        limit: 10,
        flags: [:DEBITS, :CREDITS]
      )
      response = client.get_account_balances(filter)
      expect(response.length).to eq(1)

      balance = response[0]
      expect(balance[:debits_pending].to_i).to eq(0)
      expect(balance[:debits_posted].to_i).to eq(111)
      expect(balance[:credits_pending].to_i).to eq(0)
      expect(balance[:credits_posted].to_i).to eq(0)
    end
  end

  describe 'query_accounts' do
    let(:account_ids) { Array.new(3) { TigerBeetle::ID.generate } }

    before do
      client.create_accounts(
        TigerBeetle::Account.new(id: account_ids[0], ledger:, code:, user_data_128: id),
        TigerBeetle::Account.new(id: account_ids[1], ledger:, code:, user_data_128: id),
        TigerBeetle::Account.new(id: account_ids[2], ledger:, code:, user_data_128: id)
      )
    end

    it 'returns found accounts' do
      response = client.query_accounts(TigerBeetle::QueryFilter.new(user_data_128: id, limit: 10))
      expect(response.length).to eq(3)

      account_1, account_2, account_3 = response
      expect(account_1[:id].to_i).to eq(account_ids[0])
      expect(account_2[:id].to_i).to eq(account_ids[1])
      expect(account_3[:id].to_i).to eq(account_ids[2])
    end
  end

  describe 'query_transfers' do
    let(:account_ids) { Array.new(2) { TigerBeetle::ID.generate } }
    let(:transfer_ids) { Array.new(3) { TigerBeetle::ID.generate } }

    before do
      client.create_accounts(
        TigerBeetle::Account.new(id: account_ids[0], ledger:, code:),
        TigerBeetle::Account.new(id: account_ids[1], ledger:, code:),
      )
      client.create_transfers(
        TigerBeetle::Transfer.new(
          id: transfer_ids[0],
          debit_account_id: account_ids[0],
          credit_account_id: account_ids[1],
          amount: 111,
          ledger:,
          code:,
          user_data_128: id
        ),
        TigerBeetle::Transfer.new(
          id: transfer_ids[1],
          debit_account_id: account_ids[1],
          credit_account_id: account_ids[0],
          amount: 222,
          ledger:,
          code:,
          user_data_128: id
        ),
        TigerBeetle::Transfer.new(
          id: transfer_ids[2],
          debit_account_id: account_ids[0],
          credit_account_id: account_ids[1],
          amount: 333,
          ledger:,
          code:,
          user_data_128: id
        )
      )
    end

    it 'returns found transfers' do
      response = client.query_transfers(TigerBeetle::QueryFilter.new(user_data_128: id, limit: 10))
      expect(response.length).to eq(3)

      transfer_1, transfer_2, transfer_3 = response
      expect(transfer_1[:id].to_i).to eq(transfer_ids[0])
      expect(transfer_2[:id].to_i).to eq(transfer_ids[1])
      expect(transfer_3[:id].to_i).to eq(transfer_ids[2])
    end
  end
end
