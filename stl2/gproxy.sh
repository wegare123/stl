#!/bin/sh
#stl (Wegare)
#udp="$(cat /root/akun/stl.txt | grep -i udp | cut -d= -f2)" 
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)" 
    echo ""
    echo "is connecting to the internet"
    tun2socks -tunAddr "10.0.0.1" -tunGw  "10.0.0.2" -tunMask "255.255.255.0" -tunName "tun1" -tunDns "8.8.8.8,8.8.4.4" -proxyType "socks" -proxyServer "127.0.0.1:1080" &
    route add "$host" gw "$route" metric 0
    route add default gw 10.0.0.2 metric 0
    
    
    
    
    