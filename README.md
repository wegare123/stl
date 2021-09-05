# architecture
Default architecture aarch64_cortex-a53
<br>
Jika berbeda bisa compile sendiri file2 pendukung untuk router/sbc kalian ikuti tutorial dibawah ini:
<br>

1) badvpn-tun2socks
<br>
git clone https://github.com/yazdan/tun2socks-Openwrt
<br>
cp -rf tun2socks-Openwrt/badvpn package/
<br>
rm -rf tun2socks-Openwrt/
<br>
make defconfig
<br>
make menuconfig
<br>
make package/badvpn/compile V=99
<br>
2) corkscrew
<br>
git clone https://github.com/pfalcon/openwrt-packages.git
<br>
cp -rf openwrt-packages/net/corkscrew package/
<br>
rm -rf openwrt-packages
<br>
make menuconfig
<br>
make package/corkscrew/compile V=99
<br>
3) sshpass
<br>
mkdir -p package/sshpass
<br>
wget --no-check-certificate "https://www.dropbox.com/s/kr1hfprl5uwrm6u/sshpass-1.06.zip" && unzip sshpass-1.06.zip && rm -rf sshpass-1.06.zip
<br>
mv sshpass-1.06 package/sshpass/src
<br>
chmod +x package/sshpass/src/*
<br>
wget --no-check-certificate "https://www.dropbox.com/s/wp4asjlqjp2ah4s/makefile" -O package/sshpass/Makefile
<br>
make package/sshpass/compile V=99


# stl
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl/install.sh" -O ~/install.sh && chmod 777 ~/install.sh && ~/./install.sh

# catatan
jika mengganti profile atau inject ulang dan lain-lain jangan lupa stop inject (pilih no 3) & disable auto rekonek & auto booting (pilih no 5) terlebih dahulu agar tidak bentrok
