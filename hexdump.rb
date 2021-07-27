# frozen_string_literal: true

require 'hexdump'

BUFFER_SIZE = 1024

loop do
  data = socket.recv(BUFFER_SIZE)
  Hexdump.dump(data)
end
