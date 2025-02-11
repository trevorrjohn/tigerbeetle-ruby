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

  class UInt128 < FFI::Struct
    layout low: :uint64, high: :uint64

    def from(value)
      self[:low] = value % 2**64
      self[:high] = value >> 64
    end

    def to_i
      self[:low] + (self[:high] << 64)
    end
  end

  class Packet < FFI::Struct
    layout :next, Packet.ptr,
           :user_data, :pointer,
           :operation, Operation,
           :status, PacketStatus,
           :data_size, :uint32,
           :data, :pointer,
           :batch_next, Packet.ptr,
           :batch_tail, Packet.ptr,
           :batch_size, :uint32,
           :batch_allowed, :bool,
           :reserved, [:uint8, 7]
  end

  class Account < FFI::Struct
    layout :id, UInt128,
           :debits_pending, UInt128,
           :debits_posted, UInt128,
           :credits_pending, UInt128,
           :credits_posted, UInt128,
           :user_data_128, UInt128,
           :user_data_64, :uint64,
           :user_data_32, :uint32,
           :reserved, :uint32,
           :ledger, :uint32,
           :code, :uint16,
           :flags, :uint16,
           :timestamp, :uint64
  end

  callback :on_completion, [:uint, :uint64, Packet.by_ref, :uint64, :pointer, :uint32], :void

  attach_function :tb_client_init, [:pointer, :pointer, :string, :uint32, :uint, :on_completion], Status
  attach_function :tb_client_submit, [:uint64, Packet.by_ref], :void
end
