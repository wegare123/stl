#!/bin/bash
#stl (Wegare)
route2="$(netstat -plantu | grep -i ssh | grep -i 1080 | grep -i listen)" 
route3="$(netstat -plantu | grep corkscrew)" 
route4="$(netstat -plantu | grep ssh | grep CLOSE_WAIT | awk '{print $6}' | wc -l)" 
var="$(cat /root/logs.txt 2>/dev/null)"

echo $route
    if [[ -z $route2 ]]; then
           printf '\n' | stl
           exit
    elif [[ -z $route3 ]]; then
           printf '\n' | stl
           exit
    elif [[ $route4 -gt '10' ]]; then
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
