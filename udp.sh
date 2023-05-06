rm install-udp
rm baca.txt
rm vnc
rm vncl
rm config.json
wget http://garinn.com/vps/udpbaru.zip;chmod 777 udpbaru.zip;unzip udpbaru.zip
chmod 777 *
chmod +x install-udp;./install-udp 53,5300,2222,1194,2200,25000,7100,7200,7300,7400,7500,7600,7700,7800,7900
