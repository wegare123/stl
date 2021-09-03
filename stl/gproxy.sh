#!/bin/bash
#stl (Wegare)
udp="$(cat /root/akun/stl.txt | grep -i udp | cut -d= -f2)" 
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)" 
    echo ""
    badvpn-tun2socks --tundev tun1 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:"$udp" --udpgw-connection-buffer-size 65535 --udpgw-transparent-dns &
    route add 8.8.8.8 gw "$route" metric 0
    route add 8.8.4.4 gw "$route" metric 0
    route add "$host" gw "$route" metric 0
    route add default gw 10.0.0.2 metric 0
    
    
    
    
    