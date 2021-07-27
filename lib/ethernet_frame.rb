# frozen_string_literal: true

# Class representation of an Ethernet Frame
class EthernetFrame
  attr_reader :bytes

  def initialize(bytes)
    @bytes = bytes
  end

  def destination_mac
    format_mac(bytes[0, 6])
  end

  def source_mac
    format_mac(bytes[6, 6])
  end

  private

  def format_mac(mac_bytes)
    mac_bytes.map do |byte|
      byte.to_s(16).rjust(2, '0')
    end.join(':').upcase
  end

  def data
    # Drop the first 14 bytes (MAC Header) and last 4 bytes (CRC Checksum)
    IPPacket.new(bytes[14...-4])
  end
end
