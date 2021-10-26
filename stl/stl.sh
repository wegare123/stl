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
pillstl2="$(cat /root/akun/pillstl.txt)"
clear

tunnel () {
nohup python3 /root/akun/tunnel.py > /dev/null 2>&1 &
sleep 1
nohup python3 /root/akun/ssh.py 1 > /dev/null 2>&1 &
echo "is connecting to the internet"
for i in {1..3}
do
sleep 3
var=`cat /root/logs.txt 2>/dev/null | grep "CONNECTED SUCCESSFULLY"|awk '{print $4}'|tail -n1`
	if [ "$var" = "SUCCESSFULLY" ];then 
		gproxy &
		break
	else
		echo "{$i}. Reconnect 5s"
		nohup python3 /root/akun/ssh.py 1 > /dev/null 2>&1 &
	fi
	echo -e "Failed!"
done
}

start () {
cek="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)"
if [[ -z $cek ]]; then
echo "anda belum membuat profile"
exit
fi
stop
pillstl="$(cat /root/akun/pillstl.txt)"
if [[ $pillstl = "1" ]]; then
ipmodem="$(route -n | grep -i 0.0.0.0 | head -n1 | awk '{print $2}')" 
echo "ipmodem=$ipmodem" > /root/akun/ipmodem.txt
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)" 
ip tuntap add dev tun1 mode tun
ifconfig tun1 10.0.0.1 netmask 255.255.255.0
tunnel
route add 8.8.8.8 gw $route metric 0
route add 8.8.4.4 gw $route metric 0
route add $host gw $route metric 0
route add default gw 10.0.0.2 metric 0
elif [[ $pillstl = "2" ]]; then
tunnel
fi
rm -r /root/logs.txt 2>/dev/null
echo '
#!/bin/bash
#stl (Wegare)
while :
do
httping m.google.com
done' > /usr/bin/ping-stl
chmod +x /usr/bin/ping-stl
/usr/bin/ping-stl > /dev/null 2>&1 &
}

stop () {
pillstl="$(cat /root/akun/pillstl.txt)"
if [[ $pillstl = "1" ]]; then
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)"
killall -q badvpn-tun2socks ssh ping-stl sshpass httping python3
route del 8.8.8.8 gw "$route" metric 0 2>/dev/null
route del 8.8.4.4 gw "$route" metric 0 2>/dev/null
route del "$host" gw "$route" metric 0 2>/dev/null
ip link delete tun1 2>/dev/null
elif [[ $pillstl = "2" ]]; then
iptables -t nat -F OUTPUT 2>/dev/null
iptables -t nat -F PROXY 2>/dev/null
iptables -t nat -F PREROUTING 2>/dev/null
killall -q redsocks python3 ssh ping-stl sshpass httping fping screen
fi
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

echo "Pilih Socks Proxy" 
echo "1. Badvpn-Tun2socks" 
echo "2. Tranparent Proxy" 
read -p "Pilih Angka : " pillstl
if [ "$pillstl" = "1" ]; then
badvpn="badvpn-tun2socks --tundev tun1 --netif-ipaddr 10.0.0.2 --netif-netmask 255.255.255.0 --socks-server-addr 127.0.0.1:1080 --udpgw-remote-server-addr 127.0.0.1:$udp --udpgw-connection-buffer-size 65535 --udpgw-transparent-dns &"
elif [ "$pillstl" = "2" ]; then
cat <<EOF> /etc/redsocks.conf
base {
	log_debug = off;
	log_info = off;
	redirector = iptables;
	redsocks_conn_max = 10000;
	rlimit_nofile = 10240;
}
redsocks {
	local_ip = 0.0.0.0;
	local_port = 8123;
	ip = 127.0.0.1;
	port = 1080;
	type = socks5;
}
redsocks {
	local_ip = 127.0.0.1;
	local_port = 8124;
	ip = 10.0.0.1;
	port = 1080;
	type = socks5;
}
redudp {
    local_ip = 127.0.0.1; 
    local_port = $udp;
    ip = 10.0.0.1;
    port = 1080;
    dest_ip = 8.8.8.8; 
    dest_port = 53; 
    udp_timeout = 30;
    udp_timeout_stream = 180;
}
dnstc {
	local_ip = 127.0.0.1;
	local_port = 5300;
}
EOF
badvpn="#!/bin/bash
#stl (Wegare)
iptables -t nat -N PROXY 2>/dev/null
iptables -t nat -A PREROUTING -i br-lan -p tcp -j PROXY
iptables -t nat -A PROXY -d 127.0.0.0/8 -j RETURN
iptables -t nat -A PROXY -d 192.168.0.0/16 -j RETURN
iptables -t nat -A PROXY -d 0.0.0.0/8 -j RETURN
iptables -t nat -A PROXY -d 10.0.0.0/8 -j RETURN
iptables -t nat -A PROXY -p tcp -j REDIRECT --to-ports 8123
iptables -t nat -A PROXY -p tcp -j REDIRECT --to-ports 8124
iptables -t nat -A PROXY -p udp --dport 53 -j REDIRECT --to-ports $udp
redsocks -c /etc/redsocks.conf -p /var/run/redsocks.pid &
"
else
echo "Anda belum memilih socks proxy"
exit
fi
cat <<EOF> /usr/bin/gproxy
$badvpn
EOF
chmod +x /usr/bin/gproxy
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
echo "$pillstl" > /root/akun/pillstl.txt
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
