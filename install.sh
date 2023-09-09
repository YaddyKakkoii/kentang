#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
blue='\033[0;34m'
ungu='\033[0;35m'
Green="\033[32m"
Red="\033[31m"
WhiteB="\e[5;37m"
BlueCyan="\e[5;36m"
Green_background="\033[42;37m"
Red_background="\033[41;37m"
Suffix="\033[0m"
pwd=$(pwd)
source /etc/os-release
mkdir -p /etc/anc/potato

wget -O /etc/anc/potato/spinner.sh "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/spinner.sh" && chmod +x spinner.sh
