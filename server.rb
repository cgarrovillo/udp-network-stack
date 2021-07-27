# frozen_string_literal: true

require 'socket'

$:.unshift File.join(__dir__, 'lib')

require 'utils'
require 'ethernet_frame'
require 'ip_packet'
require 'udp_datagram'

INTERFACE_NAME = 'eth1'
UDP_PORT = 4321
# Size in bytes of a C `ifreq` structure on a 64-bit system
# struct ifreq {
#     char ifr_name[IFNAMSIZ]; /* Interface name */
#     union {
#         struct sockaddr ifr_addr;
#         struct sockaddr ifr_dstaddr;
#         struct sockaddr ifr_broadaddr;
#         struct sockaddr ifr_netmask;
#         struct sockaddr ifr_hwaddr;
#         short           ifr_flags;
#         int             ifr_ifindex;
#         int             ifr_metric;
#         int             ifr_mtu;
#         struct ifmap    ifr_map;
#         char            ifr_slave[IFNAMSIZ];
#         char            ifr_newname[IFNAMSIZ];
#         char           *ifr_data;
#     };
# };
IFREQ_SIZE = 0x0028

# Size in bytes of the `ifr_ifindex` field in the `ifreq` structure
IFINDEX_SIZE = 0x0004

# Operation number to fetch the "index" of the interface
SIOCGIFINDEX = 0x8933

socket = Socket.open(:PACKET, :RAW)

# Convert the interface name into a string of bytes
ifreq = [INTERFACE_NAME].pack("a#{IFREQ_SIZE}")

# Perform the syscall to look for the network interface "eth1"
socket.ioctl(SIOCGIFINDEX, ifreq)

# Pull the bytes containing the result out of the string
# (where the `ifr_ifindex` field would be)
index = ifreq[Socket::IFNAMSIZ, IFINDEX_SIZE]

sockaddr_ll = [Socket::AF_PACKET].pack('s')
sockaddr_ll << [ETH_P_ALL].pack('s')
sockaddr_ll << index
sockaddr_ll << ("\x00" * (SOCKADDR_LL_SIZE - sockaddr_ll.length))

socket.bind(sockaddr_ll)



# https://en.wikipedia.org/wiki/List_of_IP_protocol_numbers
UDP_PROTOCOL = 0x11 # UDP
loop do
  data = socket.recv(BUFFER_SIZE).bytes

  frame = EthernetFrame.new(data)

  next unless frame.ip_packet.protocol == UDP_PROTOCOL &&
    frame.ip_packet.udp_datagram.destination_port == 4321

  UDPSocket.new.send(
    frame.ip_packet.udp_datagram.body.upcase,
    0,
    frame.ip_packet.source_ip_address,
    frame.ip_packet.udp_datagram.source_port
  )
end


