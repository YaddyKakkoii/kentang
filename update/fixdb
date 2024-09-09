#!/bin/bash

vmessws=$(cat /etc/default/syncron/paradis/paradis.json | grep "^###ws")
vmessgrpc=$(cat /etc/default/syncron/paradis/paradis.json | grep "^###grpc")
vlessws=$(cat /etc/default/syncron/sketsa/sketsa.json | grep "^###ws")
vlessgrpc=$(cat /etc/default/syncron/sketsa/sketsa.json | grep "^###grpc")
trojanws=$(cat /etc/default/syncron/drawit/drawit.json | grep "^###ws")
trojangrpc=$(cat /etc/default/syncron/drawit/drawit.json | grep "^###grpc")
dbvmess=$(cat /etc/.vmess)
dbvless=$(cat /etc/.vless)
dbtrojan=$(cat /etc/.trojan)

wget --no-check-certificate -O databasexv "https://raw.githubusercontent.com/potatonc/TermuxInstallerPotato/master/databasexv" > /dev/null 2>&1
chmod 777 databasexv
mv databasexv /usr/sbin/

echo -n > /etc/rycle/vmess/data
echo -n > /etc/rycle/vless/data
echo -n > /etc/rycle/trojan/data

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  echo "${user}" | grep "^trial" > /dev/null
  if [[ ${?} == 1 ]]; then
    sed -i "/\b${user}\b/d" /etc/.vmess
  fi
  if [[ ${exp} == '' ]]; then
    sed -i "/\b${user}\b/d" /etc/.vmess
  fi
  if [[ ${uuid} == '' ]]; then
    sed -i "/\b${user}\b/d" /etc/.vmess
  fi
done <<< "${dbvmess}"

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  echo "${user}" | grep "^trial" > /dev/null
  if [[ ${?} == 1 ]]; then
    sed -i "/\b${user}\b/d" /etc/.vless
  fi
  if [[ ${exp} == '' ]]; then
    sed -i "/\b${user}\b/d" /etc/.vless
  fi
  if [[ ${uuid} == '' ]]; then
    sed -i "/\b${user}\b/d" /etc/.vless
  fi
done <<< "${dbvless}"

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  echo "${user}" | grep "^trial" > /dev/null
  if [[ ${?} == 1 ]]; then
    sed -i "/\b${user}\b/d" /etc/.trojan
  fi
  if [[ ${exp} == '' ]]; then
    sed -i "/\b${user}\b/d" /etc/.trojan
  fi
  if [[ ${uuid} == '' ]]; then
    sed -i "/\b${user}\b/d" /etc/.trojan
  fi
done <<< "${dbtrojan}"

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  if [[ ${user} != '' ]]; then
    echo "${user}" | grep "^trial" > /dev/null
    if [[ ${?} == 1 ]]; then
      cat /etc/.vmess | grep "^### ${user}" > /dev/null
      if [[ ${?} == 0 ]]; then
        sed -i "/\b${user}\b/d" /etc/.vmess
      fi
      echo "### ${user} ${exp} ${uuid}" >> /etc/.vmess
    elif [[ ${?} == 0 ]]; then
      continue
    fi
  fi
done <<< "${vmessws}"

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  if [[ ${user} != '' ]]; then
    echo "${user}" | grep "^trial" > /dev/null
    if [[ ${?} == 1 ]]; then
      cat /etc/.vmess | grep "^### ${user}" > /dev/null
      if [[ ${?} == 0 ]]; then
        sed -i "/\b${user}\b/d" /etc/.vmess
      fi
      echo "### ${user} ${exp} ${uuid}" >> /etc/.vmess
    elif [[ ${?} == 0 ]]; then
      continue
    fi
  fi
done <<< "${vmessgrpc}"

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  if [[ ${user} != '' ]]; then
    echo "${user}" | grep "^trial" > /dev/null
    if [[ ${?} == 1 ]]; then
      cat /etc/.vless | grep "^### ${user}" > /dev/null
      if [[ ${?} == 0 ]]; then
        sed -i "/\b${user}\b/d" /etc/.vless
      fi
      echo "### ${user} ${exp} ${uuid}" >> /etc/.vless
    elif [[ ${?} == 0 ]]; then
      continue
    fi
  fi
done <<< "${vlessws}"

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  if [[ ${user} != '' ]]; then
    echo "${user}" | grep "^trial" > /dev/null
    if [[ ${?} == 1 ]]; then
      cat /etc/.vless | grep "^### ${user}" > /dev/null
      if [[ ${?} == 0 ]]; then
        sed -i "/\b${user}\b/d" /etc/.vless
      fi
      echo "### ${user} ${exp} ${uuid}" >> /etc/.vless
    elif [[ ${?} == 0 ]]; then
      continue
    fi
  fi
done <<< "${vlessgrpc}"

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  if [[ ${user} != '' ]]; then
    echo "${user}" | grep "^trial" > /dev/null
    if [[ ${?} == 1 ]]; then
      cat /etc/.trojan | grep "^### ${user}" > /dev/null
      if [[ ${?} == 0 ]]; then
        sed -i "/\b${user}\b/d" /etc/.trojan
      fi
      echo "### ${user} ${exp} ${uuid}" >> /etc/.trojan
    elif [[ ${?} == 0 ]]; then
      continue
    fi
  fi
done <<< "${trojanws}"

while read line; do
  set -- ${line}
  user="${2}"
  exp="${3}"
  uuid="${4}"
  if [[ ${user} != '' ]]; then
    echo "${user}" | grep "^trial" > /dev/null
    if [[ ${?} == 1 ]]; then
      cat /etc/.trojan | grep "^### ${user}" > /dev/null
      if [[ ${?} == 0 ]]; then
        sed -i "/\b${user}\b/d" /etc/.trojan
      fi
      echo "### ${user} ${exp} ${uuid}" >> /etc/.trojan
    elif [[ ${?} == 0 ]]; then
      continue
    fi
  fi
done <<< "${trojangrpc}"
echo "Done!"
rm -f fixdb > /dev/null 2>&1
exit 0
