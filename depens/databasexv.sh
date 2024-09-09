#!/bin/bash

syncron="/etc/default/syncron"

vmessws=$(cat "${syncron}/paradis/paradis.json" | grep "^###ws" | awk '{print $2}' | sort -u)
vlessws=$(cat "${syncron}/sketsa/sketsa.json" | grep "^###ws" | awk '{print $2}' | sort -u)
trojanws=$(cat "${syncron}/drawit/drawit.json" | grep "^###ws" | awk '{print $2}' | sort -u)
vmessgrpc=$(cat "${syncron}/paradis/paradis.json" | grep "^###grpc" | awk '{print $2}' | sort -u)
vlessgrpc=$(cat "${syncron}/sketsa/sketsa.json" | grep "^###grpc" | awk '{print $2}' | sort -u)
trojangrpc=$(cat "${syncron}/drawit/drawit.json" | grep "^###grpc" | awk '{print $2}' | sort -u)

function vmess() {
  while read user; do
    if [[ "${user}" != "" ]]; then
      exp=$(cat "${syncron}/paradis/paradis.json" | grep "^###ws" | grep -w "${user}" | awk '{print $3}' | sort -u)
      uuid=$(cat "$syncron/paradis/paradis.json" | grep "^###ws" | grep -w "${user}" | awk '{print $4}' | sort -u)
      cat /etc/.vmess | grep -w "${user}" > /dev/null
      if [[ ${?} -eq 1 ]]; then
        echo "### ${user} ${exp} ${uuid}" >> /etc/.vmess
      fi
    fi
  done <<< "${vmessws}"
  
  while read user; do
    if [[ "${user}" != "" ]]; then
      exp=$(cat "${syncron}/paradis/paradis.json" | grep "^###grpc" | grep -w "${user}" | awk '{print $3}' | sort -u)
      uuid=$(cat "$syncron/paradis/paradis.json" | grep "^###grpc" | grep -w "${user}" | awk '{print $4}' | sort -u)
      cat /etc/.vmess | grep -w "${user}" > /dev/null
      if [[ ${?} -eq 1 ]]; then
        echo "### ${user} ${exp} ${uuid}" >> /etc/.vmess
      fi
    fi
  done <<< "${vmessgrpc}"
}

function vless() {
  while read user; do
    if [[ "${user}" != "" ]]; then
      exp=$(cat "${syncron}/sketsa/sketsa.json" | grep "^###ws" | grep -w "${user}" | awk '{print $3}' | sort -u)
      uuid=$(cat "${syncron}/sketsa/sketsa.json" | grep "^###ws" | grep -w "${user}" | awk '{print $4}' | sort -u)
      cat /etc/.vless | grep -w "${user}" > /dev/null
      if [[ ${?} -eq 1 ]]; then
        echo "### ${user} ${exp} ${uuid}" >> /etc/.vless
      fi
    fi
  done <<< "${vlessws}"
  
  while read user; do
    if [[ "${user}" != "" ]]; then
      exp=$(cat "${syncron}/sketsa/sketsa.json" | grep "^###grpc" | grep -w "${user}" | awk '{print $3}' | sort -u)
      uuid=$(cat "${syncron}/sketsa/sketsa.json" | grep "^###grpc" | grep -w "${user}" | awk '{print $4}' | sort -u)
      cat /etc/.vless | grep -w "${user}" > /dev/null
      if [[ ${?} -eq 1 ]]; then
        echo "### ${user} ${exp} ${uuid}" >> /etc/.vless
      fi
    fi
  done <<< "${vlessgrpc}"
}

function trojan() {
  while read user; do
    if [[ "${user}" != "" ]]; then
      exp=$(cat "${syncron}/drawit/drawit.json" | grep "^###ws" | grep -w "${user}" | awk '{print $3}' | sort -u)
      uuid=$(cat "${syncron}/drawit/drawit.json" | grep "^###ws" | grep -w "${user}" | awk '{print $4}' | sort -u)
      cat /etc/.trojan | grep -w "${user}" > /dev/null
      if [[ ${?} -eq 1 ]]; then
        echo "### ${user} ${exp} ${uuid}" >> /etc/.trojan
      fi
    fi
  done <<< "${trojanws}"
  
  while read user; do
    if [[ "${user}" != "" ]]; then
      exp=$(cat "${syncron}/drawit/drawit.json" | grep "^###grpc" | grep -w "${user}" | awk '{print $3}' | sort -u)
      uuid=$(cat "${syncron}/drawit/drawit.json" | grep "^###grpc" | grep -w "${user}" | awk '{print $4}' | sort -u)
      cat /etc/.trojan | grep -w "${user}" > /dev/null
      if [[ ${?} -eq 1 ]]; then
        echo "### ${user} ${exp} ${uuid}" >> /etc/.trojan
      fi
    fi
  done <<< "${trojangrpc}"
}

vmess
vless
trojan



