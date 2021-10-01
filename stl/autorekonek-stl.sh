#!/bin/bash
#stl (Wegare)
route="$(route | grep -i 8.8.8.8 | head -n1 | awk '{print $2}')" 
route2="$(route | grep -i 10.0.0.2 | head -n1 | awk '{print $2}')" 
route3="$(netstat -plantu | grep -i ssh | grep -i 1080 | grep -i listen)" 
route4="$(netstat -plantu | grep corkscrew)" 
route5="$(netstat -plantu | grep ssh | grep CLOSE_WAIT | awk '{print $6}' | wc -l)" 
var="$(cat /root/logs.txt 2>/dev/null)"

echo $route
	if [[ -z $route2 ]]; then
		   printf '\n' | stl
           exit
    elif [[ -z $route3 ]]; then
           printf '\n' | stl
           exit
    elif [[ -z $route ]]; then
           printf '\n' | stl
           exit
    elif [[ -z $route4 ]]; then
           printf '\n' | stl
           exit
    elif [[ $route5 -gt '5' ]]; then
           printf '\n' | stl
           exit
    else 
      if [[ -z $var ]]; then
           echo > /dev/null
      else
		   printf '\n' | stl
           exit
       fi
	fi
