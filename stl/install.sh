#!/bin/bash
#stl (Wegare)
printf 'ctrl+c' | crontab -e >/dev/null
opkg update && opkg install unzip
cek=$(cat /etc/openwrt_r*)
if [[ $cek == *"LEDE"* ]] && [[ $cek == *"ar71xx"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/lede/ar71xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ar71xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ar71xx
elif [[ $cek == *"LEDE"* ]] && [[ $cek == *"brcm63xx"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/lede/brcm63xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/brcm63xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/brcm63xx
elif [[ $cek == *"LEDE"* ]] && [[ $cek == *"ramips"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/lede/ramips.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ramips/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ramips
elif [[ $cek == *"LEDE"* ]] && [[ $cek == *"sunxi"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/lede/sunxi.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/sunxi/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/sunxi
elif [[ $cek == *"Chaos Calmer"* ]] && [[ $cek == *"ar71xx"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/cc/ar71xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ar71xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ar71xx
elif [[ $cek == *"Chaos Calmer"* ]] && [[ $cek == *"brcm63xx"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/cc/brcm63xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/brcm63xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/brcm63xx
elif [[ $cek == *"Chaos Calmer"* ]] && [[ $cek == *"ramips"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/cc/ramips.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ramips/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ramips
elif [[ $cek == *"Chaos Calmer"* ]] && [[ $cek == *"sunxi"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/cc/sunxi.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/sunxi/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/sunxi
elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"aarch64_cortex-a53"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/sunxi.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/sunxi/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/sunxi
elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"aarch64_generic"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/armv8.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/armv8/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/armv8
elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"mips_24kc"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/ar71xx.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ar71xx/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ar71xx
elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"mipsel_24kc"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/ramips.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/ramips/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/ramips
####elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"x86"* ]]; then
#wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/i386-pentium.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/i386-pentium/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/i386-pentium
elif [[ $cek == *"OpenWrt"* ]] && [[ $cek == *"x86_64"* ]]; then
  wget --no-check-certificate "https://github.com/wegare123/backup/blob/main/openwrt/x86_64.zip?raw=true" -O ~/ekstrak.zip && unzip ~/ekstrak.zip && cp ~/x86_64/*.ipk ~/ && rm -rf ~/ekstrak.zip && rm -rf ~/x86_64
else
  echo -e "version anda tidak terdeteksi!"
  echo -e "silahkan install sendiri paket pendukungnya!"
fi
mkdir -p ~/akun/
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl/stl.sh" -O /usr/bin/stl
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl/autorekonek-stl.sh" -O /usr/bin/autorekonek-stl
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl/tunnel.py" -O /root/akun/tunnel.py
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl/ssh.py" -O /root/akun/ssh.py
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl/inject.py" -O /root/akun/inject.py
opkg install openvpn-openssl && opkg install ip-full && opkg install openssh-client && opkg install stunnel && opkg install --force-depends *.ipk && opkg install lsof && opkg install httping fping screen python python3 coreutils-nohup libevent2 redsocks
chmod +x /usr/bin/stl
chmod +x /root/akun/tunnel.py
chmod +x /root/akun/ssh.py
chmod +x /root/akun/inject.py
chmod +x /usr/bin/autorekonek-stl
rm -r ~/*.ipk
rm -r ~/install.sh
mkdir -p ~/.ssh/
touch ~/akun/ssl.conf
touch ~/.ssh/config
touch ~/akun/stl.txt
touch ~/akun/ipmodem.txt
sleep 2
echo "install selesai"
echo "untuk memulai tools silahkan jalankan perintah 'stl'"
