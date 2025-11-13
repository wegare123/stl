#!/bin/bash
#stl (Wegare)
while true; do
       #route1="$(netstat -plantu | grep corkscrew)"
       #route2="$(netstat -plantu | grep -i ssh | grep -i 1080 | grep -i listen)"
       #route3="$(netstat -plantu | grep ssh | grep CLOSE_WAIT | awk '{print $6}' | wc -l)"
       var="$(cat /root/logs.txt 2>/dev/null)"

       #if [[ -z $route1 ]]; then
       #       printf '\n' | stl &
       #if [[ -z $route2 ]]; then
       #       nohup python3 /root/akun/ssh.py 1 >/dev/null 2>&1 &
       #       sleep 3
       #       var_cek=$(cat /root/logs.txt 2>/dev/null | grep "CONNECTED SUCCESSFULLY" | awk '{print $4}' | tail -n1)
       #       if [ "$var_cek" = "SUCCESSFULLY" ]; then
       #              rm -r /root/logs.txt 2>/dev/null
       #       else
       #              echo "{$i}. Reconnect 3s"
       #              nohup python3 /root/akun/ssh.py 1 >/dev/null 2>&1 &
       #       fi
       #elif [[ $route3 -gt '10' ]]; then
       #       printf '\n' | stl &

       #else
       if [[ -z $var ]]; then
              echo >/dev/null
       else
              nohup python3 /root/akun/ssh.py 1 >/dev/null 2>&1 &
              sleep 3
              var_cek=$(cat /root/logs.txt 2>/dev/null | grep "CONNECTED SUCCESSFULLY" | awk '{print $4}' | tail -n1)
              if [ "$var_cek" = "SUCCESSFULLY" ]; then
                     rm -r /root/logs.txt 2>/dev/null
              else
                     echo "{$i}. Reconnect 3s"
                     nohup python3 /root/akun/ssh.py 1 >/dev/null 2>&1 &
              fi
       fi
       #fi
done
