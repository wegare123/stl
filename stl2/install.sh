#!/bin/sh
#stl (Wegare)
printf 'ctrl+c' | crontab -e > /dev/null
opkg update && opkg install wget
cek=$(uname -m)
if [[ $cek == "mips" ]]; then
wget --no-check-certificate "https://github.com/wegare123/stl/blob/main/stl2/tun2socks-mips?raw=true" -O /usr/bin/tun2socks
wget --no-check-certificate "https://github.com/wegare123/stl/blob/main/stl2/sshpass_1.06-wegare_mips.ipk?raw=true" -O ~/tun2socks.ipk
elif [[ $cek == "x86" ]]; then
wget --no-check-certificate "https://github.com/wegare123/stl/blob/main/stl2/tun2socks-386?raw=true" -O /usr/bin/tun2socks
wget --no-check-certificate "https://github.com/wegare123/stl/blob/main/stl2/sshpass_1.06-wegare_i386_pentium.ipk?raw=true" -O ~/tun2socks.ipk
else
echo -e "version anda tidak terdeteksi!"
exit
fi
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl2/stl.sh" -O /usr/bin/stl
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl2/gproxy.sh" -O /usr/bin/gproxy
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl2/autorekonek-stl.sh" -O /usr/bin/autorekonek-stl
opkg install openvpn && opkg install ip-full && opkg install openssh-client && opkg install stunnel && opkg install *.ipk && opkg install lsof && opkg install fping && opkg install screen
chmod +x /usr/bin/gproxy
chmod +x /usr/bin/stl
chmod +x /usr/bin/autorekonek-stl
chmod +x /usr/bin/tun2socks
rm -r ~/*.ipk
rm -r ~/install.sh
mkdir -p ~/akun/
mkdir -p ~/.ssh/
touch ~/akun/ssl.conf
touch ~/.ssh/config
touch ~/akun/stl.txt
sleep 2
echo "install selesai"
echo "untuk memulai tools silahkan jalankan perintah 'stl'"

				