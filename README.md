# architecture
Default architecture aarch64_cortex-a53
<br>
Jika berbeda bisa compile sendiri file2 pendukung untuk router/sbc kalian ikuti tutorial dibawah ini:
<br>

1. Badvpn
git clone https://github.com/yazdan/tun2socks-Openwrt
cp -rf tun2socks-Openwrt/badvpn package/
rm -rf tun2socks-Openwrt/
<br>
make defconfig
<br>
make menuconfig
<br>
make package/badvpn/compile V=99
2. corkscrew
git clone https://github.com/pfalcon/openwrt-packages.git
<br>
cp -rf openwrt-packages/net/corkscrew package/
<br>
rm -rf openwrt-packages
<br>
make menuconfig
<br>
make package/corkscrew/compile V=99

# stl
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/stl/main/stl/install.sh" -O ~/install.sh && chmod 777 ~/install.sh && ~/./install.sh

# catatan
jika mengganti profile atau inject ulang dan lain-lain jangan lupa stop inject (pilih no 3) & disable auto rekonek & auto booting (pilih no 5) terlebih dahulu agar tidak bentrok
