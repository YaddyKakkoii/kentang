#!/bin/bash

ISP=$(watchgnupg1 ~/.myisp | tr -d '\n')
CITY=$(watchgnupg1 ~/.mycity | tr -d '\n')
MYIP=$(watchgnupg1 ~/.myip | tr -d '\n');
domain=$(cat /etc/xray/domain)
syncron="/etc/default/syncron"
log="/var/log/xray"

function convert() {
    local -i bytes=$1;
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$(( (bytes + 1023)/1024 ))KB"
    elif [[ $bytes -lt 1073741824 ]]; then
        echo "$(( (bytes + 1048575)/1048576 ))MB"
    else
        echo "$(( (bytes + 1073741823)/1073741824 ))GB"
    fi
}

tim2sec() {
    mult=1
    arg="$1"
    res=0
    while [ ${#arg} -gt 0 ]; do
        prev="${arg%:*}"
        if [ "$prev" = "$arg" ]; then
            curr="${arg#0}"  # avoid interpreting as octal
            prev=""
        else
            curr="${arg##*:}"
            curr="${curr#0}"  # avoid interpreting as octal
        fi
        curr="${curr%%.*}"  # remove any fractional parts
        res=$((res+curr*mult))
        mult=$((mult*60))
        arg="$prev"
    done
    echo "$res"
}



# SSH Dropbear OpenVPN
function Dropbear() {
dirt="/tmp/"

if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi
                
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in ${data[@]}
do
        cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
        NUM=`cat /tmp/login-db-pid.txt | wc -l`;
        sincedb=`cat /tmp/login-db-pid.txt | awk '{print $1,$2,$3}'`;
        USER=`cat /tmp/login-db-pid.txt | awk '{print $10}' | tr -d "'"`;
        IP=`cat /tmp/login-db-pid.txt | awk '{print $12}' | cut -d: -f1`;
        if [ $NUM -eq 1 ]; then
          echo "☞ <code>${USER} ${PID}</code>" >> /tmp/userDropbear.txt
        fi
done
}

function SSH() {
if [ -e "/var/log/auth.log" ]; then
  LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
  LOG="/var/log/secure";
fi
data=$(ps aux | grep -i dropbear | awk '{print $2}');
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in ${data[@]}
do
  cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
  NUM=`cat /tmp/login-db-pid.txt | wc -l`;
  sincedb=`cat /tmp/login-db-pid.txt | awk '{print $1,$2,$3}'`;
  USER=`cat /tmp/login-db-pid.txt | awk '{print $10}' | tr -d "'"`;
  IP=`cat /tmp/login-db-pid.txt | awk '{print $12}' | cut -d: -f1`;
  if [ $NUM -eq 1 ]; then
    echo "${USER}" >> /tmp/sincesd
  fi
done
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-ssh.txt
data2=$(ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}');

for PID in ${data2[@]}
do
  cat /tmp/login-ssh.txt | grep "sshd\[$PID\]" > /tmp/login-ssh-pid.txt;
  NUM=`cat /tmp/login-ssh-pid.txt | wc -l`;
  sincesh=`cat /tmp/login-ssh-pid.txt | awk '{print $1,$2,$3}'`;
  USER=`cat /tmp/login-ssh-pid.txt | awk '{print $9}'`;
  IP=`cat /tmp/login-ssh-pid.txt | awk '{print $11}'`;
  if [ $NUM -eq 1 ]; then
    echo "${USER}" >> /tmp/sincesd
  fi
done
if [[ -e /tmp/sincesd ]]; then
  if [[ $(cat /tmp/sincesd) != '' ]]; then
    dirapihin=$(cat /tmp/sincesd | sort -u)
    while read rapih; do
    set -- ${rapih}
    USER="${1}"
    totalin=$(cat /tmp/sincesd | grep -w "${USER}" | wc -l)
    echo "☞ <code>${USER} ${totalin} PID</code>" >> /tmp/userSSH.txt
    done <<< "${dirapihin}"
    rm -f /tmp/sincesd > /dev/null 2>&1
  fi
fi
}

function OpenVPNTCP() {
 if [ -f "${dir_vpn}server-tcp.log" ]; then
        line=`cat ${dir_vpn}server-tcp.log | wc -l`
        a=$((3+((line-8)/2)))
        b=$(((line-8)/2))
        echo " "
  
  cat ${dir_vpn}server-tcp.log | head -n $a | tail -n $b | cut -d "," -f 1,2,5 | sed -e 's/,/   /g' > ${dirt}vpn-tcp.txt
  cat ${dirt}vpn-tcp.txt | awk '{print $1}' > ${dirt}1
  cat ${dirt}vpn-tcp.txt | awk '{print $2}' | cut -d: -f1 > ${dirt}2
  cat ${dirt}vpn-tcp.txt | awk '{print $4,$5,$6,$7}' > ${dirt}3
  cat ${dirt}1 > /tmp/userOpenvpn.txt
  rm -f ${dirt}1
  rm -f ${dirt}2
  rm -f ${dirt}3
fi
}

function OpenVPNUDP() {
 if [ -f "${dir_vpn}server-udp.log" ]; then
        line=`cat ${dir_vpn}server-udp.log | wc -l`
        a=$((3+((line-8)/2)))
        b=$(((line-8)/2))
        echo " "
  
  cat ${dir_vpn}server-udp.log | head -n $a | tail -n $b | cut -d "," -f 1,2,5 | sed -e 's/,/   /g' > ${dirt}vpn-udp.txt
  cat ${dirt}vpn-udp.txt | awk '{print $1}' > ${dirt}1
  cat ${dirt}vpn-udp.txt | awk '{print $2}' | cut -d: -f1 > ${dirt}2
  cat ${dirt}vpn-udp.txt | awk '{print $4,$5,$6,$7}' > ${dirt}3
  cat ${dirt}1 > /tmp/userOpenvpn.txt
  rm -f ${dirt}1
  rm -f ${dirt}2
  rm -f ${dirt}3
fi
}

# Vmess Vless Trojan
function Vmess() {
log="/var/log/xray"
data=$(cat /etc/.vmess | grep '^###' | cut -d ' ' -f2 | sort | uniq);
echo -n > /tmp/rotate
  for user in ${data[@]}; do
    logvmess=$(cat "/var/log/xray/access.log" | grep -w "email" | grep -w "${user}" | tail -n 50 | awk '{print $3}' | sed 's/tcp://g' | sed 's/tcp//g' | sed 's/:0//g' | sed 's/\[//g' | sed 's/\]//g' | sort -u | sed '/^$/d' | sed 's/\./ /g' | sed '/^$/d' | awk '!seen[$0]++')
    if [[ ${logvmess} != '' ]]; then
    if [[ ${user} != '' ]]; then
    echo -n > /tmp/rotate
    while read ip; do
      set -- ${ip}
      if [[ ${ip} != '' && ${ip} =~ ^[0-9\ ]+$ ]]; then
        timenow=$(TZ='Asia/Jakarta' date "+%Y-%m-%d %T %s" | awk '{print $2}')
        timesvmess=$(cat "${log}/access.log" | grep -w "email: ${user}" | grep -w "${1}.${2}.${3}" | awk '{print $2}' | tail -n 1)
        if [[ ${timesvmess} != '' ]]; then
          cat /tmp/rotate | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
          if [[ ${?} -eq 1 ]]; then
            #calcu=$(( (${limit} * 15 + 1) ))
            now=$(tim2sec ${timenow})
            client=$(tim2sec ${timesvmess})
            oc=$(( (${now} - ${client}) ))
            openvcsguys=$(echo "${oc}" | sed 's/-//g')
            if [[ ${openvcsguys} -lt 20 ]]; then
              cat /tmp/rotate | grep -w "${user}" | awk '{print $2}' | grep -w "^${1}.${2}" > /dev/null
              if [[ ${?} -eq 0 ]]; then
              z=$(cat /tmp/rotate | grep -w "${user}" | cut -d. -f3 | tail -n 1)
              if [[ ${z} != '' ]]; then
                po=$(( (${z} - ${3}) ))
                ta=$(( (${z} + ${3}) ))
                min=$(echo "${po}" | sed 's/-//g')
                plus=$(echo "${ta}" | sed 's/-//g')
                if [[ ${min} != 1 && ${min} != 2 && ${min} != 3 && ${min} != 4 && ${plus} != 1 && ${plus} != 2 && ${plus} != 3 && ${plus} != 4 ]]; then
                  cat /tmp/rotate | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                  if [[ ${?} -eq 1 ]]; then
                    echo "${user} ${1}.${2}.${3}" >> /tmp/rotate
                  fi
                fi
              elif [[ ${z} == '' ]]; then
                cat /tmp/rotate | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                if [[ ${?} -eq 1 ]]; then
                  echo "${user} ${1}.${2}.${3}" >> /tmp/rotate
                fi
              fi
              else
                cat /tmp/rotate | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                if [[ ${?} -eq 1 ]]; then
                  echo "${user} ${1}.${2}.${3}" >> /tmp/rotate
                fi
              fi
            fi
          fi
        fi
      fi
    done <<< "${logvmess}"
    fi
    fi
if [[ $(cat /tmp/rotate) != '' ]]; then
result=$(cat /tmp/rotate | grep -w "${user}" | wc -l)
if [[ ${result} -gt 0 ]]; then
if [[ -e /etc/potatonc/vmess/${user} ]]; then
byt=$(cat /etc/potatonc/vmess/${user})
gb=$(convert ${byt})
else
gb=""
fi
if [[ -e /etc/potatonc/limit/vmess/${user} ]]; then
byte=$(cat /etc/potatonc/limit/vmess/${user})
lim=$(convert ${byte})
else
lim=""
fi
my_log=$(cat "${log}/access.log" | grep -w "email: ${user}" | wc -l)

echo "${user} ${gb} ${result}IP | ${my_log}" >> /tmp/userVmess.txt
fi
#sleep 0.1
fi
  done
}

function Vless() {
log="/var/log/xray"
data2=$(cat /etc/.vless | grep '^###' | cut -d ' ' -f2 | sort | uniq);
echo -n > /tmp/rotate1
  for user in ${data2[@]}; do
    logvless=$(cat "/var/log/xray/access2.log" | grep -w "email" | grep -w "${user}" | tail -n 50 | awk '{print $3}' | sed 's/tcp://g' | sed 's/tcp//g' | sed 's/:0//g' | sed 's/\[//g' | sed 's/\]//g' | sort -u | sed '/^$/d' | sed 's/\./ /g' | sed '/^$/d' | awk '!seen[$0]++')
    if [[ ${logvless} != '' ]]; then
    if [[ ${user} != '' ]]; then
    echo -n > /tmp/rotate1
    while read ip; do
      set -- ${ip}
      if [[ ${ip} != '' && ${ip} =~ ^[0-9\ ]+$ ]]; then
        timenow=$(TZ='Asia/Jakarta' date "+%Y-%m-%d %T %s" | awk '{print $2}')
        timesvless=$(cat "${log}/access2.log" | grep -w "email: ${user}" | grep -w "${1}.${2}.${3}" | awk '{print $2}' | tail -n 1)
        if [[ ${timesvless} != '' ]]; then
          cat /tmp/rotate1 | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
          if [[ ${?} -eq 1 ]]; then
            #calcu=$(( (${limit} * 15 + 1) ))
            now=$(tim2sec ${timenow})
            client=$(tim2sec ${timesvless})
            oc=$(( (${now} - ${client}) ))
            openvcsguys=$(echo "${oc}" | sed 's/-//g')
            if [[ ${openvcsguys} -lt 20 ]]; then
              cat /tmp/rotate1 | grep -w "${user}" | awk '{print $2}' | grep -w "^${1}.${2}" > /dev/null
              if [[ ${?} -eq 0 ]]; then
              z=$(cat /tmp/rotate1 | grep -w "${user}" | cut -d. -f3 | tail -n 1)
              if [[ ${z} != '' ]]; then
                po=$(( (${z} - ${3}) ))
                ta=$(( (${z} + ${3}) ))
                min=$(echo "${po}" | sed 's/-//g')
                plus=$(echo "${ta}" | sed 's/-//g')
                if [[ ${min} != 1 && ${min} != 2 && ${min} != 3 && ${min} != 4 && ${plus} != 1 && ${plus} != 2 && ${plus} != 3 && ${plus} != 4 ]]; then
                  cat /tmp/rotate1 | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                  if [[ ${?} -eq 1 ]]; then
                    echo "${user} ${1}.${2}.${3}" >> /tmp/rotate1
                  fi
                fi
              elif [[ ${z} == '' ]]; then
                cat /tmp/rotate1 | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                if [[ ${?} -eq 1 ]]; then
                  echo "${user} ${1}.${2}.${3}" >> /tmp/rotate1
                fi
              fi
              else
                cat /tmp/rotate1 | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                if [[ ${?} -eq 1 ]]; then
                  echo "${user} ${1}.${2}.${3}" >> /tmp/rotate1
                fi
              fi
            fi
          fi
        fi
      fi
    done <<< "${logvless}"
    fi
    fi
if [[ $(cat /tmp/rotate1) != '' ]]; then
result1=$(cat /tmp/rotate1 | grep -w "${user}" | wc -l)
if [[ ${result1} -gt 0 ]]; then
if [[ -e /etc/potatonc/vless/${user} ]]; then
byt=$(cat /etc/potatonc/vless/${user})
gb=$(convert ${byt})
else
gb=""
fi
if [[ -e /etc/potatonc/limit/vless/${user} ]]; then
byte=$(cat /etc/potatonc/limit/vless/${user})
lim=$(convert ${byte})
else
lim=""
fi
my_log=$(cat "${log}/access2.log" | grep -w "email: ${user}" | wc -l)

echo "${user} ${gb} ${result1}IP | ${my_log}" >> /tmp/userVless.txt
fi
fi
  done
}

function Trojan() {
  log="/var/log/xray"
  data3=$(cat /etc/.trojan | grep '^###' | cut -d ' ' -f2 | sort | uniq);
  echo -n > /tmp/rotate
  for user in ${data3[@]}; do
    #echo "${user}"
    logtrojan=$(cat "/var/log/xray/access3.log" | grep -w "email" | grep -w "${user}" | tail -n 50 | awk '{print $3}' | sed 's/tcp://g' | sed 's/tcp//g' | sed 's/:0//g' | sed 's/\[//g' | sed 's/\]//g' | sort -u | sed '/^$/d' | sed 's/\./ /g' | sed '/^$/d' | awk '!seen[$0]++')
    if [[ ${logtrojan} != '' ]]; then
    if [[ ${user} != '' ]]; then
    echo -n > /tmp/rotate
    while read ip; do
      set -- ${ip}
      if [[ ${ip} != '' && ${ip} =~ ^[0-9\ ]+$ ]]; then
        timenow=$(TZ='Asia/Jakarta' date "+%Y-%m-%d %T %s" | awk '{print $2}')
        timestrojan=$(cat "${log}/access3.log" | grep -w "email: ${user}" | grep -w "${1}.${2}.${3}" | awk '{print $2}' | tail -n 1)
        if [[ ${timestrojan} != '' ]]; then
          cat /tmp/rotate | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
          if [[ ${?} -eq 1 ]]; then
            #calcu=$(( (${limit} * 15 + 1) ))
            now=$(tim2sec ${timenow})
            client=$(tim2sec ${timestrojan})
            oc=$(( (${now} - ${client}) ))
            openvcsguys=$(echo "${oc}" | sed 's/-//g')
            if [[ ${openvcsguys} -lt 20 ]]; then
              cat /tmp/rotate | grep -w "${user}" | awk '{print $2}' | grep -w "^${1}.${2}" > /dev/null
              if [[ ${?} -eq 0 ]]; then
              z=$(cat /tmp/rotate | grep -w "${user}" | cut -d. -f3 | tail -n 1)
              if [[ ${z} != '' ]]; then
                po=$(( (${z} - ${3}) ))
                ta=$(( (${z} + ${3}) ))
                min=$(echo "${po}" | sed 's/-//g')
                plus=$(echo "${ta}" | sed 's/-//g')
                if [[ ${min} != 1 && ${min} != 2 && ${min} != 3 && ${min} != 4 && ${plus} != 1 && ${plus} != 2 && ${plus} != 3 && ${plus} != 4 ]]; then
                  cat /tmp/rotate | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                  if [[ ${?} -eq 1 ]]; then
                    echo "${user} ${1}.${2}.${3}" >> /tmp/rotate
                  fi
                fi
              elif [[ ${z} == '' ]]; then
                cat /tmp/rotate | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                if [[ ${?} -eq 1 ]]; then
                  echo "${user} ${1}.${2}.${3}" >> /tmp/rotate
                fi
              fi
              else
                cat /tmp/rotate | grep -w "${user}" | grep -w "${1}.${2}.${3}" > /dev/null
                if [[ ${?} -eq 1 ]]; then
                  echo "${user} ${1}.${2}.${3}" >> /tmp/rotate
                fi
              fi
            fi
          fi
        fi
      fi
    done <<< "${logtrojan}"
    fi
    fi
if [[ $(cat /tmp/rotate) != '' ]]; then
result=$(cat /tmp/rotate | grep -w "${user}" | wc -l)
if [[ ${result} -gt 0 ]]; then
if [[ -e /etc/potatonc/trojan/${user} ]]; then
byt=$(cat /etc/potatonc/trojan/${user})
gb=$(convert ${byt})
else
gb=""
fi
if [[ -e /etc/potatonc/limit/trojan/${user} ]]; then
byte=$(cat /etc/potatonc/limit/trojan/${user})
lim=$(convert ${byte})
else
lim=""
fi
my_log=$(cat "${log}/access3.log" | grep -w "email: ${user}" | wc -l)

echo "${user} ${gb} ${result}IP | ${my_log}" >> /tmp/userTrojan.txt
fi
#sleep 0.1
fi
  done
}

# Send to bot
function sendDB() {
dblog=$(cat /tmp/userDropbear.txt | sort -u)

# send bot
if [[ -n ${dblog} ]]; then
source /usr/sbin/getdb

TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>   Script Auto Install by Potato</code>
<code>————————————————————————————————————</code>
<code>      ✨USER LOGIN DROPBEAR✨</code>
<code>————————————————————————————————————</code>
<code>
IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>————————————————————————————————————</code>
${dblog}
"

viewctl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
rm -f /tmp/userDropbear.txt > /dev/null 2>&1
fi
rm -f /tmp/userDropbear.txt > /dev/null 2>&1
}

function sendSSH() {
sshlog=$(cat /tmp/userSSH.txt)

# send bot
if [[ -n ${sshlog} ]]; then
source /usr/sbin/getdb

TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>   Script Auto Install by Potato</code>
<code>————————————————————————————————————</code>
<code>     ✨USER LOGIN SSH/Dropbear✨</code>
<code>————————————————————————————————————</code>
<code>
IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>————————————————————————————————————</code>
${sshlog}
"

viewctl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
rm -f /tmp/userSSH.txt > /dev/null 2>&1
fi
rm -f /tmp/userSSH.txt > /dev/null 2>&1
}

function sendOpenvpnTCP() {
vpnlog=$(cat /tmp/userOpenvpn.txt)

# send bot
if [[ -n ${vpnlog} ]]; then
source /usr/sbin/getdb

TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>   Script Auto Install by Potato</code>
<code>————————————————————————————————————</code>
<code>     ✨USER LOGIN OPENVPN TCP✨</code>
<code>————————————————————————————————————</code>
<code>
IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>————————————————————————————————————</code>
${vpnlog}
"

viewctl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
rm -f /tmp/userOpenvpn.txt > /dev/null 2>&1
fi
rm -f /tmp/userOpenvpn.txt > /dev/null 2>&1
}

function sendOpenvpnUDP() {
vpnlog=$(cat /tmp/userOpenvpn.txt)

# send bot
if [[ -n ${vpnlog} ]]; then
source /usr/sbin/getdb

TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>   Script Auto Install by Potato</code>
<code>————————————————————————————————————</code>
<code>     ✨USER LOGIN OPENVPN UDP✨</code>
<code>————————————————————————————————————</code>
<code>
IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>————————————————————————————————————</code>
${vpnlog}
"

viewctl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
rm -f /tmp/userOpenvpn.txt > /dev/null 2>&1
fi
rm -f /tmp/userOpenvpn.txt > /dev/null 2>&1
}

function sendVmess() {
log=$(cat /tmp/userVmess.txt)

# send bot
if [[ -n ${log} ]]; then
source /usr/sbin/getdb

TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>   Script Auto Install by Potato</code>
<code>————————————————————————————————————</code>
<code>        ✨USER LOGIN VMESS✨</code>
<code>————————————————————————————————————</code>
<code>
IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>————————————————————————————————————</code>
${log}
"

viewctl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
rm -f /tmp/userVmess.txt > /dev/null 2>&1
fi
rm -f /tmp/userVmess.txt > /dev/null 2>&1
}

function sendVless() {
log=$(cat /tmp/userVless.txt)

# send bot
if [[ -n ${log} ]]; then
source /usr/sbin/getdb

TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>   Script Auto Install by Potato</code>
<code>————————————————————————————————————</code>
<code>        ✨USER LOGIN VLESS✨</code>
<code>————————————————————————————————————</code>
<code>
IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>————————————————————————————————————</code>
${log}
"

viewctl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
rm -f /tmp/userVless.txt > /dev/null 2>&1
fi
rm -f /tmp/userVless.txt > /dev/null 2>&1
}

function sendTrojan() {
log=$(cat /tmp/userTrojan.txt)

# send bot
if [[ -n ${log} ]]; then
source /usr/sbin/getdb

TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>   Script Auto Install by Potato</code>
<code>————————————————————————————————————</code>
<code>       ✨USER LOGIN TROJAN✨</code>
<code>————————————————————————————————————</code>
<code>
IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>————————————————————————————————————</code>
${log}
"

viewctl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
rm -f /tmp/userTrojan.txt > /dev/null 2>&1
fi
rm -f /tmp/userTrojan.txt > /dev/null 2>&1
}

function ssh_bot() {
if [ -e /etc/.cachelogssh ]; then
  akun=$(cat /etc/.cachelogssh)
  if [[ "${#akun}" -gt 1 ]]; then
  if [ -e /usr/sbin/getdb ]; then
# send bot
source /usr/sbin/getdb

TIME="10"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TEXT="
<code>————————————————————————————————————</code>
<code>                 SSH</code>
<code>————————————————————————————————————</code>
<code>        List User Multi Login</code>
<code>————————————————————————————————————</code>
<code>
IP     : ${MYIP}
DOMAIN : ${domain}
</code>
<code>————————————————————————————————————</code>
${akun}
<code>————————————————————————————————————</code>
Note :
the user's active period will be reduced at 23:56 WIB
if you don't want the account to have its active period reduced, please login to your vps and type the command or copy this code ☞ <code>rm -f /etc/.killssh</code>

user akan dikurangi masa aktif nya pada jam 23:56 WIB
jika anda tidak ingin akun tersebut dikurangi masa aktif nya, silahkan login ke vps anda dan ketik perintah atau salin code ini ☞ <code>rm -f /etc/.killssh</code>
"

viewctl -s --max-time $TIME -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
  fi
  fi
fi
}

SSH
if [ -e /tmp/userSSH.txt ]; then
sendSSH
fi
#sleep 1
#Dropbear
#if [ -e /tmp/userDropbear.txt ]; then
#sendDB
#fi
#sleep 1
OpenVPNTCP
if [ -e /tmp/userOpenvpn.txt ]; then
sendOpenvpnTCP
fi
#sleep 1
OpenVPNUDP
if [ -e /tmp/userOpenvpn.txt ]; then
sendOpenvpnUDP
fi
#sleep 1
Vmess
if [ -e /tmp/userVmess.txt ]; then
sendVmess
fi
#sleep 1
Vless
if [ -e /tmp/userVless.txt ]; then
sendVless
fi
#sleep 1
Trojan
if [ -e /tmp/userTrojan.txt ]; then
sendTrojan
fi

#ssh_bot
#rm -f /etc/.cachelogssh
