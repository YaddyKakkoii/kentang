#!/bin/bash


# setting vnstat
#apt-get -y install vnstat
apt-get remove vnstat -y
apt-get purge vnstat -y

NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)

while :; do
  wget -q -O vnstat.tar.gz "http://scriptcjxrq91ay.potatonc.my.id/depens/vnstatlatest" > /dev/null 2>&1
  if [[ $(stat -c%s vnstat.tar.gz) -gt 1000 ]]; then
    tar zxvf vnstat.tar.gz
    break
  else
    sleep 2
  fi
done

cd vnstat-2.10
chmod +x configure
./configure --prefix=/usr --sysconfdir=/etc --disable-dependency-tracking && make && make install
cp -v examples/systemd/simple/vnstat.service /etc/systemd/system/
cp -v examples/init.d/debian/vnstat /etc/init.d/
cd ..
sed -i 's/Interface "eth0"/Interface "'""$NIC""'"/g' /etc/vnstat.conf;
sed -i 's/;Interface "eth0"/Interface "'""$NIC""'"/g' /etc/vnstat.conf;
#chown vnstat:vnstat /var/lib/vnstat -R
systemctl daemon-reload
systemctl disable vnstat
systemctl enable vnstat
systemctl start vnstat
update-rc.d vnstat defaults
service vnstat start
vnstat --add -i ${NIC}
systemctl restart vnstat
service vnstat restart
rm -rf vnstat-2.10
rm -f vnstat.tar.gz

clear
echo "Done..."
echo ""

rm -f "$0" > /dev/null 2>&1

