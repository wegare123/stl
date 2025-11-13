#!/bin/bash
#stl (Wegare)
while true; do
       cek_tunnel="$(netstat -plantu | grep -i python3 | grep -i 9092 | grep -i listen)"
       if [[ -z $cek_tunnel ]]; then
              killall -q python3
              nohup python3 /root/akun/tunnel.py 1 >/dev/null 2>&1 &
              sleep 1
       fi

       cek_ssh="$(netstat -plantu | grep -i ssh | grep -i 1080 | grep -i listen)"
       if [[ -z $cek_ssh ]]; then
              killall -q ssh sshpass
              nohup python3 /root/akun/ssh.py 1 >/dev/null 2>&1 &
              sleep 3
              var_cek=$(cat /root/logs.txt 2>/dev/null | grep "CONNECTED SUCCESSFULLY" | awk '{print $4}' | tail -n1)
              if [ "$var_cek" = "SUCCESSFULLY" ]; then
                     rm -r /root/logs.txt 2>/dev/null
              fi
       else
              var="$(cat /root/logs.txt 2>/dev/null)"
              if [[ -z $var ]]; then
                     echo >/dev/null
              else
                     killall -q ssh sshpass
                     nohup python3 /root/akun/ssh.py 1 >/dev/null 2>&1 &
                     sleep 3
                     var_cek=$(cat /root/logs.txt 2>/dev/null | grep "CONNECTED SUCCESSFULLY" | awk '{print $4}' | tail -n1)
                     if [ "$var_cek" = "SUCCESSFULLY" ]; then
                            rm -r /root/logs.txt 2>/dev/null
                     fi
              fi
       fi

       pillstl="$(cat /root/akun/pillstl.txt)"
       if [[ $pillstl = "1" ]]; then
              cek_badvpn="$(netstat -plantu | grep -i badvpn)"
              if [[ -z $cek_badvpn ]]; then
                     killall -q badvpn-tun2socks
                     gproxy
                     sleep 3
              fi
       elif [[ $pillstl = "2" ]]; then
              cek_redsocks="$(netstat -plantu | grep -i redsocks)"
              if [[ -z $cek_redsocks ]]; then
                     iptables -t nat -F OUTPUT 2>/dev/null
                     iptables -t nat -F PROXY 2>/dev/null
                     iptables -t nat -F PREROUTING 2>/dev/null
                     killall -q redsocks
                     gproxy
                     sleep 3
              fi
       fi
       sleep 1
done
