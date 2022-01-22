#!/bin/bash

echo Copyright FAS

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
#cek cache dari aplikasi
du -sh /var/cache/apt/archives

#Bersihkan semua yang ada di file log
logs=`find /var/log -type f`
for i in $logs
 do
     > $i
 done
 
echo "=============== RESTART ==============="
pkill python
pkill node
systemctl stop bad
/etc/init.d/dropbear restart
/etc/init.d/stunnel4 restart
systemctl restart bad
service openvpn restart
systemctl restart nodews
systemctl restart wsssl
#apt-get clean && apt-get autoclean
#apt-get autoremove -y

echo "=============== HAPUS TONG SAMPAH ==============="
rm -rf /home/*/.local/share/Trash/*/**
rm -rf /root/.local/share/Trash/*/*

echo "=============== HAPUS LOG ==============="
find /var/log -type f -regex ".*\.gz$" | xargs rm -Rf
find /var/log -type f -regex ".*\.[0-9]$" | xargs rm -Rf

echo "=============== HAPUS CACHE ==============="
sync; echo 3 > /proc/sys/vm/drop_caches

sync; echo 2 > /proc/sys/vm/drop_caches

sync; echo 1 > /proc/sys/vm/drop_caches

 echo
 echo "Proses bersih-bersih sudah selesai!"
 echo "Coba cek lagi deh hardisk kamu!"
 echo "by FAS"
