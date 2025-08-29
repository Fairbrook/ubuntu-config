#!/bin/bash
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2025.03.09_all.deb keyring.deb SHA256:2c2601e6053d5c68c2c60bcd088fa9797acec5f285151d46de9c830aaba6173c
sudo apt install ./keyring.deb
echo "deb [signed-by=/usr/share/keyrings/sur5r-keyring.gpg] http://debian.sur5r.net/i3/ $(grep '^VERSION_CODENAME=' /etc/os-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt update
sudo apt install i3

sudo wget -O /usr/bin/i3exit https://gist.githubusercontent.com/Fairbrook/40d04fed59068d3be57a7014c9085987/raw/4d18543b7ea4fc035de1f3d2cf06411b5943f4b4/i3exit
sudo chmod +x /usr/bin/i3exit

sudo apt install -y polybar rofi
