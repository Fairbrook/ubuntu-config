git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
npm install -g eslint_d @fsouza/prettierd
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
# Config files
sudo rm -r ~/.config/nvim
git clone https://github.com/Fairbrook/nvim_config.git ~/.config/nvim
