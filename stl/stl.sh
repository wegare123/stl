#!/bin/bash
#stl (Wegare)
udp2="$(cat /root/akun/stl.txt | grep -i udp | cut -d= -f2)" 
user2="$(cat /root/akun/stl.txt | grep -i user | cut -d= -f2 | head -n1)" 
host2="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)"
port2="$(cat /root/akun/stl.txt | grep -i port | cut -d= -f2 | head -n1)" 
bug2="$(cat /root/akun/stl.txt | grep -i bug | cut -d= -f2)" 
pass2="$(cat /root/akun/stl.txt | grep -i pass | cut -d= -f2)" 
pp2="$(cat /root/akun/stl.txt | grep -i pp | cut -d= -f2 | tail -n1)" 
payload2="$(cat /root/akun/stl.txt | grep -i payload | cut -d= -f2)" 
proxy2="$(cat /root/akun/stl.txt | grep -i proxy | cut -d= -f2)" 
met2="$(cat /root/akun/stl.txt | grep -i met | cut -d= -f2 | head -n1)" 
clear

start () {
cek="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)"
if [[ -z $cek ]]; then
echo "anda belum membuat profile"
exit
fi
stop
ipmodem="$(route -n | grep -i 0.0.0.0 | head -n1 | awk '{print $2}')" 
echo "ipmodem=$ipmodem" > /root/akun/ipmodem.txt
ip tuntap add dev tun1 mode tun
ifconfig tun1 10.0.0.1 netmask 255.255.255.0
clear
nohup python3 /root/akun/tunnel.py > /dev/null 2>&1 &
sleep 1
nohup python3 /root/akun/ssh.py 1 > /dev/null 2>&1 &
echo "is connecting to the internet"
for i in {1..3}
do
sleep 5
var=`cat /root/logs.txt | grep "CONNECTED SUCCESSFULLY"|awk '{print $4}'`
	if [ "$var" = "SUCCESSFULLY" ];then 
		gproxy &
		break
	else
		echo "Reconnect 5s"
	fi
	echo -e "Failed!"
	stop
done
rm -r /root/logs.txt

echo '
#!/bin/bash
#stl (Wegare)
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)"
fping -l $host' > /usr/bin/ping-stl
chmod +x /usr/bin/ping-stl
/usr/bin/ping-stl > /dev/null 2>&1 &
}

stop () {
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)"
killall -q badvpn-tun2socks ssh ping-stl stunnel sshpass screen fping python3
route del 8.8.8.8 gw "$route" metric 0 2>/dev/null
route del 8.8.4.4 gw "$route" metric 0 2>/dev/null
route del "$host" gw "$route" metric 0 2>/dev/null
ip link delete tun1 2>/dev/null
/etc/init.d/dnsmasq restart 2>/dev/null
}

config () {
cat <<EOF> /root/akun/settings.ini
[mode]

connection_mode = $modeconfig

[config]
payload = $payload
proxyip = $proxy
proxyport = $pp

auto_replace = 1

[ssh]
host = $host
port = $port
username = $user
password = $pass

[sni]
server_name = $bug   

EOF
}

echo "Inject http/https/direct/sp by wegare"
echo "1. Sett Profile"
echo "2. Start Inject"
echo "3. Stop Inject"
echo "4. Enable auto booting & auto rekonek"
echo "5. Disable auto booting & auto rekonek"
echo "e. exit"
read -p "(default tools: 2) : " tools
[ -z "${tools}" ] && tools="2"
if [ "$tools" = "1" ]; then
echo "Pilih inject http/https/direct/sp" 
echo "Keterangan: " 
echo "http     = http proxy + payload" 
echo "https    = ssl/tls direct" 
echo "direct   = ssh direct + payload" 
echo "sp       = ssl/tls + payload" 
echo "" 
read -p "default inject: $met2 : " met
[ -z "${met}" ] && met="$met2"

echo "Masukkan host/ip" 
read -p "default host/ip: $host2 : " host
[ -z "${host}" ] && host="$host2"

echo "Masukkan port" 
read -p "default port: $port2 : " port
[ -z "${port}" ] && port="$port2"

echo "Masukkan user" 
read -p "default user: $user2 : " user
[ -z "${user}" ] && user="$user2"

echo "Masukkan pass" 
read -p "default pass: $pass2 : " pass
[ -z "${pass}" ] && pass="$pass2"

echo "Masukkan port udpgw" 
read -p "default udpgw: $udp2 : " udp
[ -z "${udp}" ] && udp="$udp2"

if [ "$met" = "http" ]; then
echo "Masukkan payload" 
read -p "default payload: $payload2 : " payload
[ -z "${payload}" ] && payload="$payload2"

echo "Masukkan proxy" 
read -p "default proxy: $proxy2 : " proxy
[ -z "${proxy}" ] && proxy="$proxy2"

echo "Masukkan port proxy" 
read -p "default port: $pp2 : " pp
[ -z "${pp}" ] && pp="$pp2"
modeconfig='1'
config

elif [ "$met" = "https" ]; then
echo "Masukkan bug" 
read -p "default bug: $bug2 : " bug
[ -z "${bug}" ] && bug="$bug2"
modeconfig='2'
config

elif [ "$met" = "direct" ]; then
echo "Masukkan payload" 
read -p "default payload: $payload2 : " payload
[ -z "${payload}" ] && payload="$payload2"
modeconfig='0'
config

elif [ "$met" = "sp" ]; then
echo "Masukkan SNI" 
read -p "default SNI: $bug2 : " bug
[ -z "${bug}" ] && bug="$bug2"
echo "Masukkan payload" 
read -p "default payload: $payload2 : " payload
[ -z "${payload}" ] && payload="$payload2"
modeconfig='3'
config

else 
echo "Anda belum memilih inject http/https/direct"
exit
fi

echo "met=$met
host=$host
port=$port
user=$user
pass=$pass
udp=$udp
payload=$payload
proxy=$proxy
pp=$pp
bug=$bug" > /root/akun/stl.txt
echo "Sett Profile Sukses"
sleep 2
clear
stl
elif [ "${tools}" = "2" ]; then
start

elif [ "${tools}" = "3" ]; then
stop
echo "Stop Suksess"
sleep 2
clear
stl
elif [ "${tools}" = "4" ]; then
cat <<EOF>> /etc/crontabs/root

# BEGIN AUTOREKONEKSTL
*/1 * * * *  autorekonek-stl
# END AUTOREKONEKSTL
EOF
sed -i '/^$/d' /etc/crontabs/root 2>/dev/null
/etc/init.d/cron restart
echo "Enable Suksess"
sleep 2
clear
stl

elif [ "${tools}" = "5" ]; then
sed -i "/^# BEGIN AUTOREKONEKSTL/,/^# END AUTOREKONEKSTL/d" /etc/crontabs/root > /dev/null
/etc/init.d/cron restart
echo "Disable Suksess"
sleep 2
clear
stl
elif [ "${tools}" = "e" ]; then
clear
exit
else 
echo -e "$tools: invalid selection."
exit
fi
