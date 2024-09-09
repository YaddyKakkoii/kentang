#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
blue='\033[0;34m'
ungu='\033[0;35m'
Green="\033[32m"
Red="\033[31m"
WhiteB="\e[0;37m"
BlueCyan="\e[0;36m"
Green_background="\033[42;37m"
Red_background="\033[41;37m"
Suffix="\033[0m"

NC='\e[0m'
MYIP=$(watchgnupg1 ~/.myip | tr -d '\n');
timenow=$(TZ='Asia/Jakarta' date "+%Y-%m-%d %T %s" | awk '{print $2}')

function convert() {
    local -i bytes=$1;
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1024000 ]]; then
        echo "$(( (bytes + 1023)/1024 ))KB"
    elif [[ $bytes -lt 1048576000 ]]; then
        echo "$(( (bytes + 1047576)/1048576 ))MB"
    elif [[ $bytes -lt 1073741824000 ]]; then
        echo "$(( (bytes + 1073740824)/1073741824 ))GB"
    else
        echo "$(( (bytes + 1073741823000)/1073741824000 ))TB"
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

function lane() {
echo -e " ${BlueCyan}————————————————————————————————————————${Suffix}"
}

function Credit_Potato() {
  sleep 1
echo -e ""
echo -e "${BlueCyan} ————————————————————————————————————————"
echo -e "      ${ungu}Terimakasih sudah menggunakan-"
echo -e "         Script Credit by Potato"
echo -e " ${BlueCyan}————————————————————————————————————————${Suffix}"
echo -e ""
exit 0
}

function LOGO() {
  clear
echo -e ""
echo -e "${BlueCyan} ————————————————————————————————————————"
echo -e "|            ${ungu}Potato Tunneling${BlueCyan}            |"
echo -e " ————————————————————————————————————————${Suffix}"
echo -e ""
}

function CHECK_Script() {
  if [ ! -e /usr/sbin/activated.plist ]; then
    LOGO
    echo -e " ${Red}You can not use this service,"
    echo -e " because this service is only for ${Green}Potato Script${Suffix}."
    Credit_Potato
  else
    echo -e " Dependencies Ready" > /dev/null 2>&1
  fi
}

function Author() {
echo -e "${BlueCyan} ————————————————————————————————————————"
echo -e "| ${blue}Instagram : @aldi_nc                   ${BlueCyan}|"
echo -e "| ${blue}Whatsapp  : +6282111196213             ${BlueCyan}|"
echo -e "| ${blue}Telegram  : @aldi_nc                   ${BlueCyan}|"
echo -e "| ${blue}Channel   : @tunnelingpotato           ${BlueCyan}|"
echo -e " ————————————————————————————————————————${Suffix}"
}

function IZIN_Potato() {
Regis=$(pmsson)

if [[ ${Regis} == 'ok' ]]; then
  return 0
else
  LOGO
  echo -e ""
  echo -e " ${Red}IP Address access is not allowed${Suffix}"
  echo -e ""
  echo -e " Price For 1 Month"
  echo -e ""
  echo -e "   1 IP Address :  3.5 USD"
  echo -e "   5 IP Address :   14 USD"
  echo -e "  10 IP Address :   28 USD"
  echo -e ""
  echo -e " Price For 1 Year"
  echo -e ""
  echo -e "   1 IP Address :    7 USD"
  echo -e "   5 IP Address :   28 USD"
  echo -e "  10 IP Address :   56 USD"
  echo -e ""
  echo -e " Purchases in USD can use Paypal or Binance Crypto"
  echo -e ""
  echo -e " If you live in Indonesia"
  echo -e ""
  echo -e "   1 IP Address : 15K"
  echo -e ""
  Author
  echo -e ""
  exit 0
fi
}

IZIN_Potato
CHECK_Script

source /etc/anc/potato/spinner.sh
syncron="/etc/default/syncron"
log="/var/log/xray"

data=$(cat /etc/.vmess | grep '^###' | cut -d ' ' -f 2 | sort | uniq);
data2=$(cat /etc/.vless | grep '^###' | cut -d ' ' -f 2 | sort | uniq);
LOGO

echo -n > /tmp/rotate
echo -n > /tmp/rotate1
function vmess() {
lane
echo -e "             ${blue}VMESS USER LOGIN"
lane
echo -e "  ${yellow}USER          USAGE   TOTAL    LOG"
lane
  for user in ${data[@]}; do
    logvmess=$(cat "/var/log/xray/access.log" | grep -w "email: ${user}" | awk '{print $3}' | sed 's/tcp://g' | tr -d "tcp" | cut -d: -f1 | sed '/^$/d' | cut -d. -f1-3 | sed 's/\./ /g' | tail -n 100 | awk '!seen[$0]++')
    if [[ ${logvmess} != '' ]]; then
    if [[ ${user} != '' ]]; then
    start_spinner "${user} - Catch IP, Under 20s"
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
    else
      start_spinner "No Accounts"
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
sleep 1
stop_spinner
sleep 0.3
printf "  %-13s %-7s %-8s %2s\n" "${user}" "${gb}" "${result} IP" "${my_log}"
fi
#sleep 0.1
else
stop_spinner
fi
  done
}
function vless() {
lane
echo -e "             ${blue}VLESS USER LOGIN"
lane
echo -e "  ${yellow}USER          USAGE   TOTAL    LOG"
lane
  for user in ${data2[@]}; do
    logvless=$(cat "/var/log/xray/access2.log" | grep -w "email: ${user}" | awk '{print $3}' | sed 's/tcp://g' | tr -d "tcp" | cut -d: -f1 | sed '/^$/d' | cut -d. -f1-3 | sed 's/\./ /g' | tail -n 100 | awk '!seen[$0]++')
    if [[ ${logvless} != '' ]]; then
    if [[ ${user} != '' ]]; then
    start_spinner "${user} - Catch IP, Under 20s"
    echo -n > /tmp/rotate1
#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
blue='\033[0;34m'
ungu='\033[0;35m'
Green="\033[32m"
Red="\033[31m"
WhiteB="\e[0;37m"
BlueCyan="\e[0;36m"
Green_background="\033[42;37m"
Red_background="\033[41;37m"
Suffix="\033[0m"

NC='\e[0m'
MYIP=$(watchgnupg1 ~/.myip | tr -d '\n');
timenow=$(TZ='Asia/Jakarta' date "+%Y-%m-%d %T %s" | awk '{print $2}')

function convert() {
    local -i bytes=$1;
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1024000 ]]; then
        echo "$(( (bytes + 1023)/1024 ))KB"
    elif [[ $bytes -lt 1048576000 ]]; then
        echo "$(( (bytes + 1047576)/1048576 ))MB"
    elif [[ $bytes -lt 1073741824000 ]]; then
        echo "$(( (bytes + 1073740824)/1073741824 ))GB"
    else
        echo "$(( (bytes + 1073741823000)/1073741824000 ))TB"
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

function lane() {
echo -e " ${BlueCyan}————————————————————————————————————————${Suffix}"
}

function Credit_Potato() {
  sleep 1
echo -e ""
echo -e "${BlueCyan} ————————————————————————————————————————"
echo -e "      ${ungu}Terimakasih sudah menggunakan-"
echo -e "         Script Credit by Potato"
echo -e " ${BlueCyan}————————————————————————————————————————${Suffix}"
echo -e ""
exit 0
}

function LOGO() {
  clear
echo -e ""
echo -e "${BlueCyan} ————————————————————————————————————————"
echo -e "|            ${ungu}Potato Tunneling${BlueCyan}            |"
echo -e " ————————————————————————————————————————${Suffix}"
echo -e ""
}

function CHECK_Script() {
  if [ ! -e /usr/sbin/activated.plist ]; then
    LOGO
    echo -e " ${Red}You can not use this service,"
    echo -e " because this service is only for ${Green}Potato Script${Suffix}."
    Credit_Potato
  else
    echo -e " Dependencies Ready" > /dev/null 2>&1
  fi
}

function Author() {
echo -e "${BlueCyan} ————————————————————————————————————————"
echo -e "| ${blue}Instagram : @aldi_nc                   ${BlueCyan}|"
echo -e "| ${blue}Whatsapp  : +6282111196213             ${BlueCyan}|"
echo -e "| ${blue}Telegram  : @aldi_nc                   ${BlueCyan}|"
echo -e "| ${blue}Channel   : @tunnelingpotato           ${BlueCyan}|"
echo -e " ————————————————————————————————————————${Suffix}"
}

function IZIN_Potato() {
Regis=$(pmsson)

if [[ ${Regis} == 'ok' ]]; then
  return 0
else
  LOGO
  echo -e ""
  echo -e " ${Red}IP Address access is not allowed${Suffix}"
  echo -e ""
  echo -e " Price For 1 Month"
  echo -e ""
  echo -e "   1 IP Address :  3.5 USD"
  echo -e "   5 IP Address :   14 USD"
  echo -e "  10 IP Address :   28 USD"
  echo -e ""
  echo -e " Price For 1 Year"
  echo -e ""
  echo -e "   1 IP Address :    7 USD"
  echo -e "   5 IP Address :   28 USD"
  echo -e "  10 IP Address :   56 USD"
  echo -e ""
  echo -e " Purchases in USD can use Paypal or Binance Crypto"
  echo -e ""
  echo -e " If you live in Indonesia"
  echo -e ""
  echo -e "   1 IP Address : 15K"
  echo -e ""
  Author
  echo -e ""
  exit 0
fi
}

IZIN_Potato
CHECK_Script

source /etc/anc/potato/spinner.sh
syncron="/etc/default/syncron"
log="/var/log/xray"

data=$(cat /etc/.vmess | grep '^###' | cut -d ' ' -f 2 | sort | uniq);
data2=$(cat /etc/.vless | grep '^###' | cut -d ' ' -f 2 | sort | uniq);
LOGO

echo -n > /tmp/rotate
echo -n > /tmp/rotate1
function vmess() {
lane
echo -e "             ${blue}VMESS USER LOGIN"
lane
echo -e "  ${yellow}USER          USAGE   TOTAL    LOG"
lane
  for user in ${data[@]}; do
    logvmess=$(cat "/var/log/xray/access.log" | grep -w "email: ${user}" | awk '{print $3}' | sed 's/tcp://g' | tr -d "tcp" | cut -d: -f1 | sed '/^$/d' | cut -d. -f1-3 | sed 's/\./ /g' | tail -n 100 | awk '!seen[$0]++')
    if [[ ${logvmess} != '' ]]; then
    if [[ ${user} != '' ]]; then
    start_spinner "${user} - Catch IP, Under 20s"
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
    else
      start_spinner "No Accounts"
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
sleep 1
stop_spinner
sleep 0.3
printf "  %-13s %-7s %-8s %2s\n" "${user}" "${gb}" "${result} IP" "${my_log}"
fi
#sleep 0.1
else
stop_spinner
fi
  done
}
function vless() {
lane
echo -e "             ${blue}VLESS USER LOGIN"
lane
echo -e "  ${yellow}USER          USAGE   TOTAL    LOG"
lane
  for user in ${data2[@]}; do
    logvless=$(cat "/var/log/xray/access2.log" | grep -w "email: ${user}" | awk '{print $3}' | sed 's/tcp://g' | tr -d "tcp" | cut -d: -f1 | sed '/^$/d' | cut -d. -f1-3 | sed 's/\./ /g' | tail -n 100 | awk '!seen[$0]++')
    if [[ ${logvless} != '' ]]; then
    if [[ ${user} != '' ]]; then
    start_spinner "${user} - Catch IP, Under 20s"
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
    else
      start_spinner "No Accounts"
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
sleep 1
stop_spinner
sleep 0.3
printf "  %-13s %-7s %-8s %2s\n" "${user}" "${gb}" "${result1} IP" "${my_log}"
fi
else
stop_spinner
fi
  done
}
vmess
vless
Credit_Potato
￼Enter    while read ip; do
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
    else
      start_spinner "No Accounts"
    fi
    fi
if [[ $(cat /tmp/rotate1) != '' ]]; then
result1=$(cat /tmp/rotate1 | grep -w "${user}" | wc -l)
if [[ ${result1} -gt 0 ]]; then
