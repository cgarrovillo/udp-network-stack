# frozen_string_literal: true

# Class representation of a UDP datagram
class UDPDatagram
  def source_port
    word16(bytes[0], bytes[1])
  end

  def destination_port
    word16(bytes[2], bytes[3])
  end

  def length
    word16(bytes[4], bytes[5])
  end

  def checksum
    word16(bytes[6], bytes[7])
  end

  # Interpret bytes `a` and `b` as a 16-bit word
  # by shifting `a` 8 bits to the left and holding
  # `b` in the rightmost 8 bits:
  #
  #     0000 0000 1010 1111
  #               ^
  #
  #     1010 1111 0000 0000
  #     ^
  #
  #  OR 0000 0000 1100 0011
  #     -------------------
  #     1010 1111 1100 0011
  #
  def word16(a, b)
    (a << 8) | b
  end

  def body
    bytes[8, (length - 8)].pack('C*')
  end
end

