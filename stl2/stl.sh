#!/bin/sh
#stl (Wegare)
clear
#udp2="$(cat /root/akun/stl.txt | grep -i udp | cut -d= -f2)" 
user2="$(cat /root/akun/stl.txt | grep -i user | cut -d= -f2)" 
host2="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)"
port2="$(cat /root/akun/stl.txt | grep -i port | cut -d= -f2 | head -n1)" 
bug2="$(cat /root/akun/stl.txt | grep -i bug | cut -d= -f2)" 
pass2="$(cat /root/akun/stl.txt | grep -i pass | cut -d= -f2)" 
pp2="$(cat /root/akun/stl.txt | grep -i pp | cut -d= -f2)" 
payload2="$(cat /root/akun/stl.txt | grep -i payload | cut -d= -f2)" 
proxy2="$(cat /root/akun/stl.txt | grep -i proxy | cut -d= -f2)" 
met2="$(cat /root/akun/stl.txt | grep -i met | cut -d= -f2 | head -n1)" 
echo "Inject http & https by wegare"
echo "1. Sett Profile"
echo "2. Start Inject"
echo "3. Stop Inject"
echo "4. Enable auto booting & auto rekonek"
echo "5. Disable auto booting & auto rekonek"
echo "e. exit"
read -p "(default tools: 2) : " tools
[ -z "${tools}" ] && tools="2"
if [ "$tools" = "1" ]; then
echo "Pilih inject http/https" 
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

#echo "Masukkan port udpgw" 
#read -p "default udpgw: $udp2 : " udp
##[ -z "${udp}" ] && udp="$udp2"

if [ "$met" = "http" ]; then
echo "Masukkan payload" 
read -p "default payload: $payload2 : " payload
[ -z "${payload}" ] && payload="$payload2"

echo "Masukkan proxy" 
read -p "default proxy: $proxy2 : " proxy
[ -z "${proxy}" ] && proxy="$proxy2"

echo "Masukkan port" 
read -p "default port: $pp2 : " pp
[ -z "${pp}" ] && pp="$pp2"

echo "#!/usr/bin/python
######################################
#########__Injector Python__##########
######################################
BIND_ADDR = '0.0.0.0'
BIND_PORT = 6969
PROXT_ADDR = '$proxy'
PROXY_PORT = $pp
PAYLOAD = '$payload'
import socket
import thread
import string
import select

TAM_BUFFER = 65535
MAX_CLIENT_REQUEST_LENGTH = 8192 * 8

def getReplacedPayload(payload, netData, hostPort, protocol):
    str = payload.replace('[netData]', netData)
    str = str.replace('[host_port]', (hostPort[0] + ':' + hostPort[1]))
    str = str.replace('[host]', hostPort[0])
    str = str.replace('[port]', hostPort[1])
    str = str.replace('[protocol]', protocol)
    str = str.replace('[crlf]', '\r\n')
    return str

def getRequestProtocol(request):
    inicio = request.find(' ', request.find(':')) + 1
    str = request[inicio:]
    fim = str.find('\r\n')

    return str[:fim]

def getRequestHostPort(request):
    inicio = request.find(' ') + 1
    str = request[inicio:]
    fim = str.find(' ')

    hostPort = str[:fim]

    return hostPort.split(':')

def getRequestNetData(request):
    return request[:request.find('\r\n')]

def receiveHttpMsg(socket):
    len = 1

    data = socket.recv(1)
    while data.find('\r\n\r\n'.encode()) == -1:
        if not data: break
        data = data + socket.recv(1)
        len += 1
        if len > MAX_CLIENT_REQUEST_LENGTH: break

    return data

def doConnect(clientSocket, serverSocket, tamBuffer):
    sockets = [clientSocket, serverSocket]
    timeout = 0
    print '<-> CONNECT started'

    while 1:
        timeout += 1
        ins, _, exs = select.select(sockets, [], sockets, 3)
        if exs: break

        if ins:
            for socket in ins:
                try:
                    data = socket.recv(tamBuffer)
                    if not data: break;

                    if socket is serverSocket:
                        clientSocket.sendall(data)
                    else:
                        serverSocket.sendall(data)

                    timeout = 0
                except:
                    break

        if timeout == 60: break

def acceptThread(clientSocket, clientAddr):
    print '<-> Client connected: ', clientAddr

    request = receiveHttpMsg(clientSocket)

    if not request.startswith('CONNECT'):
        print '<!> Client requisitou metodo != CONNECT!'
        clientSocket.sendall('HTTP/1.1 405 Only_CONNECT_Method!\r\n\r\n')
        clientSocket.close()
        thread.exit()

    netData = getRequestNetData(request)
    protocol = getRequestProtocol(request)
    hostPort = getRequestHostPort(netData)

    finalRequest = getReplacedPayload(PAYLOAD, netData, hostPort, protocol)

    proxySocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    proxySocket.connect((PROXT_ADDR, PROXY_PORT))
    proxySocket.sendall(finalRequest)

    proxyResponse = receiveHttpMsg(proxySocket)

    print '<-> Status line: ' + getRequestNetData(proxyResponse)

    clientSocket.sendall(proxyResponse)

    if proxyResponse.find('200 ') != -1:
        doConnect(clientSocket, proxySocket, TAM_BUFFER)

    print '<-> Client ended    : ', clientAddr
    proxySocket.close()
    clientSocket.close()
    thread.exit()


#############################__INICIO__########################################

print '\n'
print '==>Injector.py'
print '-->Listening   : ' + BIND_ADDR + ':' + str(BIND_PORT)
print '-->Remote proxy: ' + PROXT_ADDR + ':' + str(PROXY_PORT)
print '-->Payload     : ' + PAYLOAD
print '\n'

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((BIND_ADDR, BIND_PORT))
server.listen(1)

print '<-> Server listening... '

#Recebe o cliente e despacha uma thread para atende-lo
while True:
    clientSocket, clientAddr = server.accept()
    thread.start_new_thread(acceptThread, tuple([clientSocket, 
clientAddr]))

server.close()" > /usr/bin/http-stl
chmod +x /usr/bin/http-stl
elif [ "$met" = "https" ]; then
echo "Masukkan bug" 
read -p "default bug: $bug2 : " bug
[ -z "${bug}" ] && bug="$bug2"
echo "[SSH]
client = yes
accept = localhost:69
connect = $host:$port
sni = $bug" > /root/akun/ssl.conf
echo "Host ssl*
    PermitLocalCommand yes
    LocalCommand gproxy %h
    DynamicForward 1080
    StrictHostKeyChecking no
    TCPKeepAlive yes
    ServerAliveInterval 30
    ServerAliveCountMax 1200
    GatewayPorts yes
Host ssl1
    HostName 127.0.0.1
    Port 69
    User $user" > /root/.ssh/config
else 
echo -e "$met: invalid selection."
exit
fi
echo "met=$met
host=$host
port=$port
user=$user
pass=$pass
#udp=$udp
payload=$payload
proxy=$proxy
pp=$pp
bug=$bug" > /root/akun/stl.txt
echo "Sett Profile Sukses"
sleep 2
clear
stl
elif [ "${tools}" = "2" ]; then
ipmodem="$(route -n | grep -i 0.0.0.0 | head -n1 | awk '{print $2}')" 
echo "ipmodem=$ipmodem" > /root/akun/ipmodem.txt
ip tuntap add dev tun1 mode tun
ifconfig tun1 10.0.0.1 netmask 255.255.255.0
clear
met="$(cat /root/akun/stl.txt | grep -i met | cut -d= -f2)" 
if [ "$met" = "http" ]; then
user="$(cat /root/akun/stl.txt | grep -i user | cut -d= -f2)" 
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)"
port="$(cat /root/akun/stl.txt | grep -i port | cut -d= -f2 | head -n1)" 
pass="$(cat /root/akun/stl.txt | grep -i pass | cut -d= -f2)" 
http-stl > /dev/null &
sleep 2
screen -d -m sshpass -p $pass ssh -oStrictHostKeyChecking=no -CND :1080 -p "$port" "$user"@"$host" -o "Proxycommand=ncat --proxy-type http --proxy 127.0.0.1:6969 %h %p"
sleep 2
gproxy &
elif [ "$met" = "https" ]; then
cek="$(ls /root/.ssh/ | grep -i know | cut -d_ -f1)" 
if [ "$cek" = "known" ]; then
rm -f /root/.ssh/known*
fi
pass="$(cat /root/akun/stl.txt | grep -i pass | cut -d= -f2)" 
stunnel /root/akun/ssl.conf > /dev/null &
sleep 1
sshpass -p $pass ssh -N ssl1 &
else
echo "anda belum membuat profile"
exit
fi
cat <<EOF> /usr/bin/ping-stl
#!/bin/bash
#stl (Wegare)
while :
do
fping -c1 10.0.0.2
sleep 1
done
EOF
chmod +x /usr/bin/ping-stl
/usr/bin/ping-stl > /dev/null 2>&1 &
elif [ "${tools}" = "3" ]; then
host="$(cat /root/akun/stl.txt | grep -i host | cut -d= -f2 | head -n1)" 
route="$(cat /root/akun/ipmodem.txt | grep -i ipmodem | cut -d= -f2 | tail -n1)" 
#killall screen
killall -q tun2socks ssh ping-stl stunnel sshpass http-stl screen
route del "$host" gw "$route" metric 0 2>/dev/null
ip link delete tun1 2>/dev/null
killall dnsmasq 
/etc/init.d/dnsmasq start > /dev/null
sleep 2
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
