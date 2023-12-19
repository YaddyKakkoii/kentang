#!/bin/bash

bck=$(ls /etc/apt/sources.list.d | grep "backport")
rm -f "/etc/apt/sources.list.d/${bck}" > /dev/null 2>&1
source /etc/os-release
pre="/etc/apt/sources.list"
cp "${pre}" /root/

function kartolo_ubuntu() {
cat > ${pre} <<-END
deb http://kartolo.sby.datautama.net.id/ubuntu/ focal main restricted universe multiverse
deb http://kartolo.sby.datautama.net.id/ubuntu/ focal-updates main restricted universe multiverse
deb http://kartolo.sby.datautama.net.id/ubuntu/ focal-security main restricted universe multiverse
deb http://kartolo.sby.datautama.net.id/ubuntu/ focal-backports main restricted universe multiverse
deb http://kartolo.sby.datautama.net.id/ubuntu/ focal-proposed main restricted universe multiverse
END
}

function kartolo_debian() {
cat > ${pre} <<-END
deb http://kartolo.sby.datautama.net.id/debian/ buster main contrib non-free
deb http://kartolo.sby.datautama.net.id/debian/ buster-updates main contrib non-free
deb http://kartolo.sby.datautama.net.id/debian-security/ buster/updates main contrib non-free
END
}

function kebo_ubuntu() {
cat > ${pre} <<-END
deb http://kebo.pens.ac.id/ubuntu/ focal main restricted universe multiverse
deb http://kebo.pens.ac.id/ubuntu/ focal-updates main restricted universe multiverse
deb http://kebo.pens.ac.id/ubuntu/ focal-security main restricted universe multiverse
deb http://kebo.pens.ac.id/ubuntu/ focal-backports main restricted universe multiverse
deb http://kebo.pens.ac.id/ubuntu/ focal-proposed main restricted universe multiverse
END
}

function kebo_debian() {
cat > ${pre} <<-END
deb http://kebo.pens.ac.id/debian/ buster main contrib non-free
deb http://kebo.pens.ac.id/debian/ buster-updates main contrib non-free
deb http://kebo.pens.ac.id/debian-security/ buster/updates main contrib non-free
END
}

function poliwangi_ubuntu() {
cat > ${pre} <<-END
deb http://mirror.poliwangi.ac.id/ubuntu/ focal main restricted universe multiverse
deb http://mirror.poliwangi.ac.id/ubuntu/ focal-updates main restricted universe multiverse
deb http://mirror.poliwangi.ac.id/ubuntu/ focal-security main restricted universe multiverse
deb http://mirror.poliwangi.ac.id/ubuntu/ focal-backports main restricted universe multiverse
deb http://mirror.poliwangi.ac.id/ubuntu/ focal-proposed main restricted universe multiverse
END
}

function poliwangi_debian() {
cat > ${pre} <<-END
deb http://mirror.poliwangi.ac.id/debian/ buster main contrib non-free
deb http://mirror.poliwangi.ac.id/debian/ buster-updates main contrib non-free
deb http://mirror.poliwangi.ac.id/debian-security/ buster/updates main contrib non-free
END
}

function sg_ubuntu() {
cat > ${pre} <<-END
deb http://download.nus.edu.sg/mirror/ubuntu/ focal main 
#deb-src http://download.nus.edu.sg/mirror/ubuntu/ focal main
END
}

function sg_debian() {
cat > ${pre} <<-END
deb http://ftp.sg.debian.org/debian/ buster main contrib non-free
#deb-src http://ftp.sg.debian.org/debian/ buster main contrib non-free
deb http://ftp.sg.debian.org/debian/ buster-updates main contrib non-free
#deb-src http://ftp.sg.debian.org/debian/ buster-updates main contrib non-free
#deb http://security.debian.org/ buster/updates main contrib non-free
#deb-src http://security.debian.org/ buster/updates main contrib non-free
END
}

function ori_ubuntu() {
cat > ${pre} <<-END
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
#deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
END
}

function ori_debian() {
cat > ${pre} <<-END
deb http://deb.debian.org/debian buster main contrib non-free
deb http://deb.debian.org/debian buster-updates main contrib non-free
deb http://deb.debian.org/debian buster-backports main contrib non-free
END
}

function getting() {
  if [[ ${ID} == 'ubuntu' && $(echo "${VERSION_ID}" |  cut -d. -f1) == 20 ]]; then
    if [[ ${1} == 'id1' ]]; then
      kartolo_ubuntu
    fi
    if [[ ${1} == 'id2' ]]; then
      kebo_ubuntu
    fi
    if [[ ${1} == 'id3' ]]; then
      poliwangi_ubuntu
    fi
    if [[ ${1} == 'sg' ]]; then
      sg_ubuntu
    fi
    if [[ ${1} == 'ori' ]]; then
      ori_ubuntu
    fi
    apt update
  fi
  
  if [[ ${ID} == 'debian' && ${VERSION_ID} == 10 ]]; then
    if [[ ${1} == 'id1' ]]; then
      kartolo_debian
    fi
    if [[ ${1} == 'id2' ]]; then
      kebo_debian
    fi
    if [[ ${1} == 'id3' ]]; then
      poliwangi_debian
    fi
    if [[ ${1} == 'sg' ]]; then
      sg_debian
    fi
    if [[ ${1} == 'ori' ]]; then
      ori_debian
    fi
    apt update
  fi
}


if [[ ${1} == 'id1' ]]; then
  getting ${1}
fi
if [[ ${1} == 'id2' ]]; then
  getting ${1}
fi
if [[ ${1} == 'id3' ]]; then
  getting ${1}
fi
if [[ ${1} == 'sg' ]]; then
  getting ${1}
fi
if [[ ${1} == 'ori' ]]; then
  getting ${1}
fi


rm -f "${0}" > /dev/null 2>&1
rm -f "repoindo" > /dev/null 2>&1
rm -f "/root/repoindo" > /dev/null 2>&1
