#!/bin/bash
REPO="https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/"
curl -L -k -sS -o potatohp "${REPO}potatohp"
mv -f potatohp /usr/sbin/
chmod +x /usr/sbin/potatohp
    while :; do
        curl -L -k -sS -4 -o /etc/openvpn/server.crt "${REPO}servercrt" > /dev/null 2>&1
        if [[ $(stat -c%s /etc/openvpn/server.crt) -gt 400 ]]; then
            break
        else
            echo "Network VPS Problem"
            sleep 2
        fi
    done
sleep 1
    while :; do
        curl -L -k -sS -4 -o /etc/openvpn/server.key "${REPO}serverkey" > /dev/null 2>&1
        if [[ $(stat -c%s /etc/openvpn/server.key) -gt 400 ]]; then
            break
        else
            echo "Network VPS Problem"
            sleep 2
        fi
    done
sleep 1
    while :; do
        curl -L -k -sS -4 -o /etc/openvpn/ca.crt "${REPO}cacrt" > /dev/null 2>&1
        if [[ $(stat -c%s /etc/openvpn/ca.crt) -gt 400 ]]; then
            break
        else
            echo "Network VPS Problem"
            sleep 2
        fi
    done
sleep 1
    while :; do
        curl -L -k -sS -4 -o /etc/openvpn/dh.pem "${REPO}dhpem" > /dev/null 2>&1
        if [[ $(stat -c%s /etc/openvpn/dh.pem) -gt 400 ]]; then
            break
        else
            echo "Network VPS Problem"
            sleep 2
        fi
    done
sleep 1

echo 'port 1194
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
#user nobody
group nogroup
persist-key
persist-tun
management 127.0.0.1 5555
status server-tcp.log
log log-tcp.log
verb 3
;ncp-disable
cipher none
auth none' >/etc/openvpn/server-tcp-1194.conf

echo 'port 25000
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
verify-client-cert none
username-as-common-name
plugin /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 20.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
push "route-method exe"
push "route-delay 2"
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
keepalive 10 120
comp-lzo
#user nobody
group nogroup
persist-key
persist-tun
status server-udp.log
log log-udp.log
verb 3
;ncp-disable
cipher none
auth none' >/etc/openvpn/server-udp-25000.conf

cd /root

# konfigurasi client
echo 'auth-user-pass
client
dev tun
proto tcp
remote aldiblues 80
persist-key
persist-tun
pull
resolv-retry infinite
nobind
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none' >/var/www/html/myvpn-tcp-80.ovpn

echo 'auth-user-pass
client
dev tun
proto udp
remote aldiblues 25000
persist-key
persist-tun
pull
resolv-retry infinite
nobind
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none' >/var/www/html/myvpn-udp-25000.ovpn

echo 'auth-user-pass
client
dev tun
proto tcp
remote aldiblues 443
persist-key
persist-tun
pull
resolv-retry infinite
nobind
comp-lzo
remote-cert-tls server
verb 3
mute 2
connect-retry 5 5
connect-retry-max 8080
mute-replay-warnings
redirect-gateway def1
script-security 2
cipher none
auth none' >/var/www/html/myvpn-ssl-443.ovpn

cd /var/www/html

wget ${REPO}potato-ohp.ovpn
wget ${REPO}Potato-modem.ovpn >> /dev/null 2>&1

# input ca
DMN=$(cat /etc/xray/domain);
IS_DOMAIN="s/aldiblues/$DMN/g";

sed -i $IS_DOMAIN /var/www/html/myvpn-tcp-80.ovpn
sed -i $IS_DOMAIN /var/www/html/myvpn-ssl-443.ovpn
sed -i $IS_DOMAIN /var/www/html/myvpn-udp-25000.ovpn
sed -i $IS_DOMAIN /var/www/html/Potato-modem.ovpn
sed -i $IS_DOMAIN /var/www/html/potato-ohp.ovpn

cd /var/www/html

# input ca
{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>myvpn-tcp-80.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>myvpn-ssl-443.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>myvpn-udp-25000.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>Potato-modem.ovpn

{
echo "<ca>"
cat "/etc/openvpn/ca.crt"
echo "</ca>"
} >>potato-ohp.ovpn

# zip config
zip myvpn-config.zip myvpn-tcp-80.ovpn myvpn-ssl-443.ovpn myvpn-udp-25000.ovpn Potato-modem.ovpn potato-ohp.ovpn

cd /root

    if [ -d /home/vps ]; then
        mkdir -p /home/vps/public_html
        cp -f /var/www/html/myvpn-config.zip /home/vps/public_html/myvpn-config.zip
        cd /home/vps/public_html/
        unzip myvpn-config.zip
    else
        mkdir -p /home/vps
        mkdir -p /home/vps/public_html
        cp -f /var/www/html/myvpn-config.zip /home/vps/public_html/
        cd /home/vps/public_html/
        unzip myvpn-config.zip
    fi

cd /root

systemctl stop openvpn@server-tcp-1194 > /dev/null 2>&1
systemctl stop openvpn@server-udp-25000 > /dev/null 2>&1
systemctl daemon-reload
service openvpn restart
systemctl enable openvpn@server-tcp-1194
systemctl start openvpn@server-tcp-1194
systemctl restart openvpn@server-tcp-1194
systemctl enable openvpn@server-udp-25000
systemctl start openvpn@server-udp-25000
systemctl restart openvpn@server-udp-25000

#service openvpn restart > /dev/null 2>&1
#systemctl restart openvpn@server-tcp-1194 > /dev/null 2>&1
#systemctl restart openvpn@server-udp-25000 > /dev/null 2>&1

#rm -f "$0" > /dev/null 2>&1
rm -f "ovpnupdate" > /dev/null 2>&1
rm -f "/root/ovpnupdate" > /dev/null 2>&1
#https://github.com/YaddyKakkoii/kentang
#PUKI="https://github.com/potatonc/webmin/raw/master/" && wget ${PUKI}potato-ohp.ovpn
#MEKI="https://raw.githubusercontent.com/potatonc/webmin/master/" && wget ${MEKI}Potato-modem.ovpn
#PELI="http://scriptcjxrq91ay.potatonc.my.id/depens/" && wget ${PELI}servercrt & wget ${PELI}serverkey & wget ${PELI}cacrt & wget ${PELI}dhpem & wget ${PELI}potatohp
#JEMBUT="https://raw.githubusercontent.com/potatonc/termux-packages/master/disabled-packages/ocaml/"
#wget --no-check-certificate -O jadul_server.crt ${JEMBUT}server.crt & wget --no-check-certificate -O jadul_server.key ${JEMBUT}server.key & wget --no-check-certificate -O jadul_ca.crt ${JEMBUT}ca.crt & wget --no-check-certificate -O jadul_dh.pem ${JEMBUT}dh.pem
#curl -L -k -sS -4 -o /etc/openvpn/server.crt "${PELI}servercrt" > /dev/null 2>&1

echo "Copy Link openvpn: ${DMN}:81/myvpn-config.zip "
