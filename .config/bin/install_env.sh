#!/bin/bash

####################################################################################
# Install Homebrew (Requires password)
####################################################################################
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
source ~/.zshrc
# Run these two commands in your terminal to add Homebrew to your PATH:
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew doctor
source ~/.zshrc

####################################################################################
# APPS
####################################################################################
# Requires password
brew install --cask zoom
brew install git
brew install --cask alacritty
brew install --cask amethyst
brew install --cask obsidian
# Screen color temperature controller. To have night shift in 2 external monitors
brew install --cask flux
# Screen capturer
brew install --cask kap
brew install --cask docker
brew install --cask google-chrome
brew install --cask brave-browser
brew install --cask spotify
brew install --cask slack
# MySql Client
brew install --cask mysqlworkbench
# Postgres Client
brew install --cask dbeaver-community

####################################################################################
# Install oh-my-zsh
####################################################################################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Install plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
# NerdFonts
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font

####################################################################################
# Install NVM
####################################################################################
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.7/install.sh | bash
source ~/.zshrc
# Install Node.js
nvm install --lts # to install the LTS version of Node
# Use or download version in .nvmrc
nvm use
# Install ttab to open iTerm2 tabs from bash scripts
# npm install -g ttab

####################################################################################
# Install Development Environment Neovim+LunarVim+Tmux and some dependencies
####################################################################################
brew install neovim
brew install rust
brew install ripgrep
brew install lazygit
# Install lunarvim
brew install fd
brew install fzf
brew install yq
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
# Install TMUX
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
echo 'TODO: Do not forget to run prefix+I to install configured plugins!!!'
echo 'TODO: Do not forget to run prefix+I to install configured plugins!!!'
echo 'TODO: Do not forget to run prefix+I to install configured plugins!!!'

####################################################################################
# Install RVM
####################################################################################
# # See http://rvm.io/rvm/install for other ways
# curl -sSL https://get.rvm.io | bash
# rvm reload
# source ~/.zshrc
# # Run rvm requirements to install various packages required to compile Ruby and native extensions.
# # This is a little scary because it actually installs the stuff, rather than simply telling you what you need. But whatever, it works.
# rvm requirements

####################################################################################
# XCode command line tool
####################################################################################
# https://mac.install.guide/commandlinetools/index.html
# xcode-select --install # Only Command Line Tools
# xcode-select -p # Checks if ok. Result example: /Library/Developer/CommandLineTools

####################################################################################
####################################################################################
# Git Configuration
####################################################################################
# git config --global user.name "Your name"
# git config --global user.email your_name@optoro.com
# git config --global push.default current
# git config --global color.ui true
# git config --global color.diff.whitespace "red reverse"
# git config -l --global

####################################################################################
# QMK Toolbox to flush Corne Keyboard Image
####################################################################################
# Seems tap is not working, just in case it can be downloaded from:
# https://github.com/qmk/qmk_toolbox/releases
# brew tap homebrew/cask-driver
# brew install --cask qmk-toolbox

####################################################################################
# Old applications
####################################################################################
# brew install --cask recordit
# brew install --cask iterm2
# brew install --cask postman

