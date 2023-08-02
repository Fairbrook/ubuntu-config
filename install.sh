#! /bin/bash
set -e

INFO_COLOR='\033[0;36m'
NC='\033[0m'
INSTALL_CMD='sudo apt-get install '
ZDOTDIR=".config/zsh"
ZDOTFILE="${ZDOTDIR}/.zshrc"
KITTYFILE=".config/kitty/kitty.conf"

if ! command -v i3 &> /dev/null
then
 $INSTALL_CMD i3
 ./install_i3.sh
fi

if ! command -v curl &> /dev/null
then
 $INSTALL_CMD curl
fi

if ! command -v zsh &> /dev/null
then
 chsh -s $(which zsh)
 $INSTALL_CMD zsh
fi


if ! command -v kitty &> /dev/null
then
 echo -e "${INFO_COLOR} Instalando kitty${NC}"
 curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
 mkdir -p ~/.local/bin
 mkdir -p ~/.local/share/applications

 #Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
 # your system-wide PATH)
 ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/

 # Place the kitty.desktop file somewhere it can be found by the OS
 cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/

 # If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
 cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/

 # Update the paths to the kitty and its icon in the kitty.desktop file(s)
 sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
 sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

 # Theme
 THEME=https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/gruvbox_dark.conf
 wget "$THEME" -P ~/.config/kitty/kitty-themes/themes
 cd ~/.config/kitty
 ln -s ./kitty-themes/themes/gruvbox_dark.conf ~/.config/kitty/theme.conf
 echo "include ./theme.conf" >> ~/$KITTYFILE
 echo "background_opacity 0.85" >> ~/$KITTYFILE
 echo "enable_audio_bell no" >> ~/$KITTYFILE
fi

if [[ ! -f ~/${ZDOTFILE} ]]; then
 echo -e "${INFO_COLOR} Configurando ZSH${NC}"
 mkdir -p ~/.config/zsh
 echo "# Generated" > ~/$ZDOTFILE
 echo "autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'" > ~/$ZDOTFILE
 echo "export ZDOTDIR=~/${ZDOTDIR}" > ~/.zshenv
 
 echo -e "${INFO_COLOR} Agregando fuentes${NC}"
 wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
 wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
 wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
 wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
 mkdir -p ~/.local/share/fonts
 mv *.ttf ~/.local/share/fonts

 echo -e "${INFO_COLOR} Agregando PowerLevel 10K${NC}"
 git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
 echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/$ZDOTFILE
 echo 'font_family MesloLGS NF' >> ~/$KITTYFILE
 echo "p10k configure ." | exec /bin/zsh

 echo -e "${INFO_COLOR} Instalando autosuggestions${NC}"
 git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
 echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/$ZDOTFILE
 echo "bindkey '^E' autosuggest-accept" >> ~/$ZDOTFILE


 echo -e "${INFO_COLOR} Instalando highlight sintax${NC}"
 git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
 echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/$ZDOTFILE


 echo -e "${INFO_COLOR} Agregando la configuracion personalizada${NC}"
 git clone https://github.com/Fairbrook/zsh_config.git ~/.config/zsh-custom
 mv ~/.config/zsh-custom/* ~/.config/zsh
 sudo rm -r ~/.config/zsh-custom
 echo "
source ~/.config/zsh/config.zsh" >> ~/$ZDOTFILE
fi

if ! command -v python3 &> /dev/null
then
 echo -e "${INFO_COLOR} Installing python${NC}"
 $INSTALL_CMD python
fi

if ! command -v pnpm &> /dev/null
then
 echo -e "${INFO_COLOR} Installing pnpm${NC}"
 curl -fsSL https://get.pnpm.io/install.sh | sh -
 echo "export PNPM_HOME=~'/.local/share/pnpm'
export PATH=\$PNPM_HOME:\$PATH" >> ~/$ZDOTFILE
fi

if ! command -v node &> /dev/null
then
 echo -e "${INFO_COLOR} Installing node${NC}"
 echo "pnpm env use --global lts" | exec /bin/zsh
fi


if ! command -v java &> /dev/null
then
 echo -e "${INFO_COLOR} Installing java${NC}"
 $INSTALL_CMD default-jre
fi

if ! command -v make &> /dev/null
then
 echo -e "${INFO_COLOR} Installing dev tools"
  $INSTALL_CMD build-essential
fi

if ! command -v watchman &> /dev/null
then
 $INSTALL_CMD watchman
fi

if ! command -v makedeb &> /dev/null
then
 echo -e "${INFO_COLOR} Installing makedeb"
 bash -ci "$(wget -qO - 'https://shlink.makedeb.org/install')"
fi

if ! command -v nvim &> /dev/null
then
 git clone 'https://mpr.makedeb.org/neovim'
 cd neovim/
 makedeb -si
 cd ..
 sudo rm -r neovim
 $INSTALL_CMD xclip
 ./install_nvim.sh
fi

if ! command -v tmux &> /dev/null
then
  ./install_tmux.sh
fi

if ! command -v flameshot &> /dev/null
then
 $INSTALL_CMD flameshot
fi

if ! command -v go &> /dev/null
then
 curl -sSL https://git.io/g-install | sh -s
fi

if ! command -v lazygit &> /dev/null
then
 LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
 curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
 tar xf lazygit.tar.gz lazygit
 sudo install lazygit /usr/local/bin
 rm -f lazygit.tar.gz
 rm -r lazygit
fi

if ! command -v pip &> /dev/null
then
 $INSTALL_CMD python3-pip
fi

if ! command -v nvr &> /dev/null
then
 pip install neovim-remote
 pip3 install neovim-remote
fi

if ! command -v tmux-sessionizer &> /dev/null
then
 $INSTALL_CMD fzf
 wget -O ~/.local/bin/tmux-sessionizer https://raw.githubusercontent.com/ThePrimeagen/.dotfiles/master/bin/.local/scripts/tmux-sessionizer
 sudo chmod +x ~/.local/bin/tmux-sessionizer
fi

if ! command -v docker &> /dev/null
then
 echo -e "${INFO_COLOR} Instalando Docker${NC}"
 $INSTALL_CMD install ca-certificates curl gnupg
 sudo install -m 0755 -d /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 sudo chmod a+r /etc/apt/keyrings/docker.gpg
 echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
 sudo systemctl start docker
 sudo systemctl enable docker
 sudo usermod -aG docker ${USER}
fi

if ! command -v imgconsole &> /dev/null
then
    wget -O ~/.local/bin/imgconsole https://gist.githubusercontent.com/Fairbrook/f15d76a5445d4f804cd1ffa5446a9836/raw/33c365eb26894677d1a85420fff0234fcba9cae1/imgconsole
    chmod +x ~/.local/bin/imgconsole
fi
