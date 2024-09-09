#!/bin/bash


function sshdropbear() {
# simple password minimal
wget -O /etc/pam.d/common-password "https://github.com/potatonc/ScriptAutoInstallPotato/raw/master/common/common-password" > /dev/null 2>&1
chmod +x /etc/pam.d/common-password

rm -f /etc/ssh/sshd_config > /dev/null 2>&1
wget https://raw.githubusercontent.com/potatonc/ScriptAutoInstallPotato/master/menu/sshd_config
chmod 777 sshd_config
mv sshd_config /etc/ssh/
service ssh restart
service sshd restart

# install dropbear
apt-get -y install dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells

# banner /etc/banner.com
wget -O /etc/default/dropbear "https://raw.githubusercontent.com/potatonc/ScriptAutoInstallPotato/master/menu/dropbear" > /dev/null 2>&1

chmod 777 /etc/default/dropbear
/etc/init.d/dropbear restart
service ssh restart
service sshd restart
}

if [[ -e /usr/sbin/activated.plist ]]; then
  sshdropbear
  clear
  echo "Done..."
  echo ""
  sleep 1
  rm -f fixdropbear > /dev/null 2>&1
  rm -f $0 > /dev/null 2>&1
else
  clear
  echo "Only Support Script Potato Tunneling"
  echo ""
  sleep 1
  rm -f fixdropbear > /dev/null 2>&1
  rm -f $0 > /dev/null 2>&1
fi

if [[ -e fixdropbear ]]; then
  rm -f fixdropbear > /dev/null 2>&1
  rm -f $0 > /dev/null 2>&1
fi
