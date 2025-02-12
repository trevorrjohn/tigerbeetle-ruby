require 'ffi'

module TBClient
  extend FFI::Library

  # TODO: Load appropriate shared lib for the platform
  ffi_lib File.expand_path('./pkg/aarch64-macos/libtb_client.dylib', __dir__)

  Status = enum(FFI::Type::UINT8, [
                  :SUCCESS, 0,
                  :UNEXPECTED,
                  :OUT_OF_MEMORY,
                  :ADDRESS_INVALID,
                  :ADDRESS_LIMIT_EXCEEDED,
                  :SYSTEM_RESOURCES,
                  :NETWORK_SUBSYSTEM])

  PacketStatus = enum(FFI::Type::UINT8, [
                      :OK, 0,
                      :TOO_MUCH_DATA,
                      :CLIENT_EVICTED,
                      :CLIENT_RELEASE_TOO_LOW,
                      :CLIENT_RELEASE_TOO_HIGH,
                      :CLIENT_SHUTDOWN,
                      :INVALID_OPERATION,
                      :INVALID_DATA_SIZE])

  Operation = enum(FFI::Type::UINT8, [
                   :PULSE, 128,
                   :CREATE_ACCOUNTS,
                   :CREATE_TRANSFERS,
                   :LOOKUP_ACCOUNTS,
                   :LOOKUP_TRANSFERS,
                   :GET_ACCOUNT_TRANSFERS,
                   :GET_ACCOUNT_BALANCES,
                   :QUERY_ACCOUNTS,
                   :QUERY_TRANSFERS])

  CreateAccountResult = enum(FFI::Type::UINT32, [
                             :OK, 0,
                             :LINKED_EVENT_FAILED, 1,
                             :LINKED_EVENT_CHAIN_OPEN, 2,
                             :IMPORTED_EVENT_EXPECTED, 22,
                             :IMPORTED_EVENT_NOT_EXPECTED, 23,
                             :TIMESTAMP_MUST_BE_ZERO, 3,
                             :IMPORTED_EVENT_TIMESTAMP_OUT_OF_RANGE, 24,
                             :IMPORTED_EVENT_TIMESTAMP_MUST_NOT_ADVANCE, 25,
                             :RESERVED_FIELD, 4,
                             :RESERVED_FLAG, 5,
                             :ID_MUST_NOT_BE_ZERO, 6,
                             :ID_MUST_NOT_BE_INT_MAX, 7,
                             :EXISTS_WITH_DIFFERENT_FLAGS, 15,
                             :EXISTS_WITH_DIFFERENT_USER_DATA_128, 16,
                             :EXISTS_WITH_DIFFERENT_USER_DATA_64, 17,
                             :EXISTS_WITH_DIFFERENT_USER_DATA_32, 18,
                             :EXISTS_WITH_DIFFERENT_LEDGER, 19,
                             :EXISTS_WITH_DIFFERENT_CODE, 20,
                             :EXISTS, 21,
                             :FLAGS_ARE_MUTUALLY_EXCLUSIVE, 8,
                             :DEBITS_PENDING_MUST_BE_ZERO, 9,
                             :DEBITS_POSTED_MUST_BE_ZERO, 10,
                             :CREDITS_PENDING_MUST_BE_ZERO, 11,
                             :CREDITS_POSTED_MUST_BE_ZERO, 12,
                             :LEDGER_MUST_NOT_BE_ZERO, 13,
                             :CODE_MUST_NOT_BE_ZERO, 14,
                             :IMPORTED_EVENT_TIMESTAMP_MUST_NOT_REGRESS, 26])

  CreateTransferResult = enum(FFI::Type::UINT32, [
                              :OK, 0,
                              :LINKED_EVENT_FAILED, 1,
                              :LINKED_EVENT_CHAIN_OPEN, 2,
                              :IMPORTED_EVENT_EXPECTED, 56,
                              :IMPORTED_EVENT_NOT_EXPECTED, 57,
                              :TIMESTAMP_MUST_BE_ZERO, 3,
                              :IMPORTED_EVENT_TIMESTAMP_OUT_OF_RANGE, 58,
                              :IMPORTED_EVENT_TIMESTAMP_MUST_NOT_ADVANCE, 59,
                              :RESERVED_FLAG, 4,
                              :ID_MUST_NOT_BE_ZERO, 5,
                              :ID_MUST_NOT_BE_INT_MAX, 6,
                              :EXISTS_WITH_DIFFERENT_FLAGS, 36,
                              :EXISTS_WITH_DIFFERENT_PENDING_ID, 40,
                              :EXISTS_WITH_DIFFERENT_TIMEOUT, 44,
                              :EXISTS_WITH_DIFFERENT_DEBIT_ACCOUNT_ID, 37,
                              :EXISTS_WITH_DIFFERENT_CREDIT_ACCOUNT_ID, 38,
                              :EXISTS_WITH_DIFFERENT_AMOUNT, 39,
                              :EXISTS_WITH_DIFFERENT_USER_DATA_128, 41,
                              :EXISTS_WITH_DIFFERENT_USER_DATA_64, 42,
                              :EXISTS_WITH_DIFFERENT_USER_DATA_32, 43,
                              :EXISTS_WITH_DIFFERENT_LEDGER, 67,
                              :EXISTS_WITH_DIFFERENT_CODE, 45,
                              :EXISTS, 46,
                              :ID_ALREADY_FAILED, 68,
                              :FLAGS_ARE_MUTUALLY_EXCLUSIVE, 7,
                              :DEBIT_ACCOUNT_ID_MUST_NOT_BE_ZERO, 8,
                              :DEBIT_ACCOUNT_ID_MUST_NOT_BE_INT_MAX, 9,
                              :CREDIT_ACCOUNT_ID_MUST_NOT_BE_ZERO, 10,
                              :CREDIT_ACCOUNT_ID_MUST_NOT_BE_INT_MAX, 11,
                              :ACCOUNTS_MUST_BE_DIFFERENT, 12,
                              :PENDING_ID_MUST_BE_ZERO, 13,
                              :PENDING_ID_MUST_NOT_BE_ZERO, 14,
                              :PENDING_ID_MUST_NOT_BE_INT_MAX, 15,
                              :PENDING_ID_MUST_BE_DIFFERENT, 16,
                              :TIMEOUT_RESERVED_FOR_PENDING_TRANSFER, 17,
                              :CLOSING_TRANSFER_MUST_BE_PENDING, 64,
                              :AMOUNT_MUST_NOT_BE_ZERO, 18,
                              :LEDGER_MUST_NOT_BE_ZERO, 19,
                              :CODE_MUST_NOT_BE_ZERO, 20,
                              :DEBIT_ACCOUNT_NOT_FOUND, 21,
                              :CREDIT_ACCOUNT_NOT_FOUND, 22,
                              :ACCOUNTS_MUST_HAVE_THE_SAME_LEDGER, 23,
                              :TRANSFER_MUST_HAVE_THE_SAME_LEDGER_AS_ACCOUNTS, 24,
                              :PENDING_TRANSFER_NOT_FOUND, 25,
                              :PENDING_TRANSFER_NOT_PENDING, 26,
                              :PENDING_TRANSFER_HAS_DIFFERENT_DEBIT_ACCOUNT_ID, 27,
                              :PENDING_TRANSFER_HAS_DIFFERENT_CREDIT_ACCOUNT_ID, 28,
                              :PENDING_TRANSFER_HAS_DIFFERENT_LEDGER, 29,
                              :PENDING_TRANSFER_HAS_DIFFERENT_CODE, 30,
                              :EXCEEDS_PENDING_TRANSFER_AMOUNT, 31,
                              :PENDING_TRANSFER_HAS_DIFFERENT_AMOUNT, 32,
                              :PENDING_TRANSFER_ALREADY_POSTED, 33,
                              :PENDING_TRANSFER_ALREADY_VOIDED, 34,
                              :PENDING_TRANSFER_EXPIRED, 35,
                              :IMPORTED_EVENT_TIMESTAMP_MUST_NOT_REGRESS, 60,
                              :IMPORTED_EVENT_TIMESTAMP_MUST_POSTDATE_DEBIT_ACCOUNT, 61,
                              :IMPORTED_EVENT_TIMESTAMP_MUST_POSTDATE_CREDIT_ACCOUNT, 62,
                              :IMPORTED_EVENT_TIMEOUT_MUST_BE_ZERO, 63,
                              :DEBIT_ACCOUNT_ALREADY_CLOSED, 65,
                              :CREDIT_ACCOUNT_ALREADY_CLOSED, 66,
                              :OVERFLOWS_DEBITS_PENDING, 47,
                              :OVERFLOWS_CREDITS_PENDING, 48,
                              :OVERFLOWS_DEBITS_POSTED, 49,
                              :OVERFLOWS_CREDITS_POSTED, 50,
                              :OVERFLOWS_DEBITS, 51,
                              :OVERFLOWS_CREDITS, 52,
                              :OVERFLOWS_TIMEOUT, 53,
                              :EXCEEDS_CREDITS, 54,
                              :EXCEEDS_DEBITS, 55])

  class UInt128 < FFI::Struct
    layout low: :uint64, high: :uint64

    def from(value)
      self[:low] = value % 2**64
      self[:high] = value >> 64
      self # allow for single line init + fill
    end

    def to_i
      self[:low] + (self[:high] << 64)
    end
  end

  class Packet < FFI::Struct
    layout next: Packet.ptr,
           user_data: :pointer,
           operation: Operation,
           status: PacketStatus,
           data_size: :uint32,
           data: :pointer,
           batch_next: Packet.ptr,
           batch_tail: Packet.ptr,
           batch_size: :uint32,
           batch_allowed: :bool,
           reserved: [:uint8, 7]
  end

  class Account < FFI::Struct
    layout id: UInt128,
           debits_pending: UInt128,
           debits_posted: UInt128,
           credits_pending: UInt128,
           credits_posted: UInt128,
           user_data_128: UInt128,
           user_data_64: :uint64,
           user_data_32: :uint32,
           reserved: :uint32,
           ledger: :uint32,
           code: :uint16,
           flags: :uint16,
           timestamp: :uint64

    def from(value)
      self[:id] = UInt128.new.from(value.id)
      self[:debits_pending] = UInt128.new.from(value.debits_pending)
      self[:debits_posted] = UInt128.new.from(value.debits_posted)
      self[:credits_pending] = UInt128.new.from(value.credits_pending)
      self[:credits_posted] = UInt128.new.from(value.credits_posted)
      self[:user_data_128] = UInt128.new.from(value.user_data_128)
      self[:user_data_64] = value.user_data_64
      self[:user_data_32] = value.user_data_32
      self[:reserved] = value.reserved
      self[:ledger] = value.ledger
      self[:code] = value.code
      self[:flags] = value.flags
      self[:timestamp] = value.timestamp
      self
    end
  end

  class Transfer < FFI::Struct
    layout  id: UInt128,
            debit_account_id: UInt128,
            credit_account_id: UInt128,
            amount: UInt128,
            pending_id: UInt128,
            user_data_128: UInt128,
            user_data_64: :uint64,
            user_data_32: :uint32,
            timeout: :uint32,
            ledger: :uint32,
            code: :uint16,
            flags: :uint16,
            timestamp: :uint64

    def from(value)
      self[:id] = UInt128.new.from(value.id)
      self[:debit_account_id] = UInt128.new.from(value.debit_account_id)
      self[:credit_account_id] = UInt128.new.from(value.credit_account_id)
      self[:amount] = UInt128.new.from(value.amount)
      self[:pending_id] = UInt128.new.from(value.pending_id)
      self[:user_data_128] = UInt128.new.from(value.user_data_128)
      self[:user_data_64] = value.user_data_64
      self[:user_data_32] = value.user_data_32
      self[:timeout] = value.timeout
      self[:ledger] = value.ledger
      self[:code] = value.code
      self[:flags] = value.flags
      self[:timestamp] = value.timestamp
      self
    end
  end

  class CreateAccountsResult < FFI::Struct
    layout :index, :uint32,
           :result, CreateAccountResult
  end

  class CreateTransfersResult < FFI::Struct
    layout :index, :uint32,
           :result, CreateTransferResult
  end

  callback :on_completion, [:uint, :uint64, Packet.by_ref, :uint64, :pointer, :uint32], :void

  attach_function :tb_client_init, [:pointer, :pointer, :string, :uint32, :uint, :on_completion], Status
  attach_function :tb_client_submit, [:pointer, Packet.by_ref], :void
end
