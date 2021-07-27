# frozen_string_literal: true

require 'socket'

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
ifreq = %w[eth1].pack("a#{IFREQ_SIZE}")

# Perform the syscall to look for the network interface "eth1"
socket.ioctl(SIOCGIFINDEX, ifreq)

# Pull the bytes containing the result out of the string, where `ifr_ifindex` field would be
index = ifreq[Socket::IFNAMSIZ, IFINDEX_SIZE]




