#!/bin/sh
#stl (Wegare)
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)"
route="$(route | grep -i $host| head -n1 | awk '{print $1}')" 
route2="$(route | grep -i 10.0.0.2 | head -n1 | awk '{print $2}')" 
route3="$(lsof -i | grep -i ssh | grep -i 1080 | grep -i listen)" 
echo $route
	if [[ -z $route2 ]]; then
		   (printf '3\n'; sleep 15; printf '\n') | stl	
           exit
    elif [[ -z $route3 ]]; then
           (printf '3\n'; sleep 15; printf '\n') | stl	
           exit
    elif [[ -z $route ]]; then
           (printf '3\n'; sleep 15; printf '\n') | stl	
           exit
	fi
