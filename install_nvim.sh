git clone --depth 1 https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..

git clone https://github.com/Fairbrook/dotfiles.git
cd dotfiles
./install.sh
cd ..

sudo rm -rf neovim dotfiles
