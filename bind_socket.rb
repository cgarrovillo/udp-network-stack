# frozen_string_literal: true

# Receive every packet
ETH_P_ALL = 0x0300

#
# struct sockaddr_ll {
#     unsigned short sll_family;   /* Always AF_PACKET */
#     unsigned short sll_protocol; /* Physical-layer protocol */
#     int            sll_ifindex;  /* Interface number */
#     unsigned short sll_hatype;   /* ARP hardware type */
#     unsigned char  sll_pkttype;  /* Packet type */
#     unsigned char  sll_halen;    /* Length of address */
#     unsigned char  sll_addr[8];  /* Physical-layer address */
# };
# Size in bytes of a C `sockaddr_ll` structure on a 64-bit system
SOCKADDR_LL_SIZE = 0x0014

sockaddr_ll = [Socket::AF_PACKET].pack('s')
sockaddr_ll << [ETH_P_ALL].pack('s')
sockaddr_ll << index
sockaddr_ll << ("\x00" * (SOCKADDR_LL_SIZE - sockaddr_ll.length))

socket.bind(sockaddr_ll)