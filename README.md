#clone sc potato , dg sedikit penyesuaian biar bisa dipakai

# pilih salah satu repo utk mempercepat proses instalasi 
```
[[ -e $(which curl) ]]
if [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]]; then
    cat <(echo "nameserver 8.8.8.8") /etc/resolv.conf > /etc/resolv.conf.tmp
    mv /etc/resolv.conf.tmp /etc/resolv.conf
fi
curl -LksS -4 "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/repoindo.sh" -o repoindo
chmod +x repoindo
./repoindo id1
./repoindo id2
./repoindo id3
./repoindo sg
./repoindo ori
```
#id 1
```
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]]; then cat <(echo "nameserver 8.8.8.8") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi && curl -LksS -4 "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/repoindo.sh" -o repoindo && chmod +x repoindo && ./repoindo id1
```
#id 2
```
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]]; then cat <(echo "nameserver 8.8.8.8") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi && curl -LksS -4 "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/repoindo.sh" -o repoindo && chmod +x repoindo && ./repoindo id2
```
#id 3
```
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]]; then cat <(echo "nameserver 8.8.8.8") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi && curl -LksS -4 "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/repoindo.sh" -o repoindo && chmod +x repoindo && ./repoindo id3
```
# sg
```
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]]; then cat <(echo "nameserver 8.8.8.8") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi && curl -LksS -4 "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/repoindo.sh" -o repoindo && chmod +x repoindo && ./repoindo sg
```
#ori
```
[[ -e $(which curl) ]] && if [[ -z $(cat /etc/resolv.conf | grep "8.8.8.8") ]]; then cat <(echo "nameserver 8.8.8.8") /etc/resolv.conf > /etc/resolv.conf.tmp && mv /etc/resolv.conf.tmp /etc/resolv.conf; fi && curl -LksS -4 "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/repoindo.sh" -o repoindo && chmod +x repoindo && ./repoindo ori
```


# OVPNUPDATE curl
```
curl -L -k -sS -4 -o ovpnupdate "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/ovpnupdate.sh" && chmod +x ovpnupdate && ./ovpnupdate
```
# OVPNUPDATE wget
```
wget -O ovpnupdate "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/ovpnupdate.sh" && chmod +x ovpnupdate && ./ovpnupdate
```
