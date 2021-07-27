# frozen_string_literal: true

# Class representation of an IPPacket
class IPPacket
  attr_reader :bytes

  def initialize(bytes)
    @bytes = bytes
  end

  def version
    bytes[0] >> 4
  end

  def ihl
    bytes[0] & 0xF
  end

  def source_ip_address
    bytes[14, 4].join('.')
  end

  def udp_datagram
    UDPDatagram.new(bytes.drop(20))
  end
end
