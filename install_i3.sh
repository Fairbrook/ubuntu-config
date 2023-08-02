sudo wget -O /usr/bin/i3exit https://gist.githubusercontent.com/Fairbrook/40d04fed59068d3be57a7014c9085987/raw/4d18543b7ea4fc035de1f3d2cf06411b5943f4b4/i3exit
sudo chmod +x /usr/bin/i3exit

sh <(curl -L https://nixos.org/nix/install) --daemon
nix-env -iA nixpkgs.xidlehook
sudo wget -O /usr/bin/idlelock https://gist.githubusercontent.com/Fairbrook/cffa64e0e2badb3bdd935b7f7dbb75bd/raw/9335e110aa13dfc8f51d2290a60216ede3e6d0ac/idlelock
sudo chmod +x /usr/bin/idlelock

pip install "cython<3.0.0" wheel && pip install pyyaml==5.4.1 --no-build-isolation
git clone https://github.com/Fairbrook/i3wm-themer.git
cd i3wm-themer/
./install_ubuntu.sh
python3 i3wm-themer.py --config config.yaml --load themes/007.json
cd ..
